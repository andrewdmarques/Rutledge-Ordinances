library(system)
library(write)
################################################################################
# User defined variables
################################################################################
url_website = "https://www.rutledgepa.org/"
dir_working = "media/andrewdmarques/Data011/Personal/Rutledge-Ordinances"
dir_data = 'Data'
# Toggles
# Download from website
toggle_download = F

################################################################################
# Run 
################################################################################

setwd(dir_working)
dir.create(dir_data, showWarnings = FALSE)

if(toggle_download == T){
  command_download = paste0("wget --mirror --convert-links --adjust-extension --page-requisites --no-parent -P ",dir_data,' ',url_website)
  system(command_download)
}

keyword_search <- function(dir_data){
  # Initialize the results data frame
  ref <- data.frame(keyword = character(),
                    context = character(),
                    file_name = character(),
                    file_location = character(),
                    stringsAsFactors = FALSE)
  
  # Function to check if a file is a text file
  is_text_file <- function(file_path) {
    mime <- system(paste("file --mime-type -b", shQuote(file_path)), intern = TRUE)
    return(grepl("text/|xml|html|json|csv|plain|script", mime))
  }
  
  # Function to extract context around a keyword
  get_context <- function(content, keyword, before = 100, after = 100) {
    matches <- gregexpr(keyword, content, ignore.case = TRUE)[[1]]
    if (matches[1] == -1) return(NULL)
    
    contexts <- sapply(matches, function(pos) {
      start <- max(1, pos - before)
      end <- min(nchar(content), pos + nchar(keyword) - 1 + after)
      substr(content, start, end)
    })
    return(contexts)
  }
  
  # Recursively list all files in the directory
  all_files <- list.files(dir_data, recursive = TRUE, full.names = TRUE)
  total_files <- length(all_files)
  processed_files <- 0
  
  # Iterate over each file
  for (file in all_files) {
    if (file.info(file)$isdir) next  # Skip directories
    
    processed_files <- processed_files + 1
    
    if (is_text_file(file)) {
      content <- tryCatch(readLines(file, warn = FALSE), error = function(e) return(NULL))
      if (is.null(content)) next
      content <- paste(content, collapse = " ")
      
      for (keyword in c("ordinance", "pave")) {
        contexts <- get_context(content, keyword)
        if (!is.null(contexts)) {
          for (context in contexts) {
            ref <- rbind(ref, data.frame(keyword = keyword,
                                         context = context,
                                         file_name = basename(file),
                                         file_location = file,
                                         stringsAsFactors = FALSE))
          }
        }
      }
    }
    
    if (processed_files %% 5 == 0 || processed_files == total_files) {
      cat(sprintf("Processed %d of %d files\n", processed_files, total_files))
    }
  }
  
  # View the results
  return(ref)
}

# Search for the keyword
ref <- keyword_search(dir_data)

# Save the file that indicates that there was keywords
write.csv(ref,'reference_v2.csv')

# Iterate through the files and if there is an index file then make it so that it can be clicked.
ref2 <- ref
ref2$website_url <- ''
for(ii in 1:nrow(ref2)){
  t1 <- ref2$file_location[ii]
  if(grepl("/index.html",t1)){
    t2 <- gsub('/index.html','',t1)
    t2 <- gsub(paste0(dir_data,'/'),'',t2)
    t2 <- paste0('https://',t2)
    ref2$website_url[ii] <- t2
  }else{
    t2 <- gsub(paste0(dir_data,'/'),'',t1)
    t2 <- paste0('https://',t2)
    ref2$website_url[ii] <- t2
  }
}

# Extract file extensions using sub() function
extensions <- sub(".*\\.", "", all_files)

# Create extensions2 where extensions longer than 5 characters are replaced with "json"
extensions2 <- ifelse(nchar(extensions) > 4, "json", extensions)

extensions3 <- data.frame(table(extensions2))

write.csv(extensions3, '2024-12-16_table-of-website-file-extensions.csv')

write.csv(ref2,'2024-12-10_website-keyword-search_v2.csv')
