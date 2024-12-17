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
write.csv(ref,'reference.csv')


keyword_search2 <- function(dir_data){
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
                                         file_location = paste0("=HYPERLINK(\"", normalizePath(file), "\")"),
                                         stringsAsFactors = FALSE))
          }
        }
      }
    }
    
    if (processed_files %% 5 == 0 || processed_files == total_files) {
      cat(sprintf("Processed %d of %d files\n", processed_files, total_files))
    }
  }
  
  # Save the results to a reference file
  output_file <- file.path(dir_data, "ref_results_v2.csv")
  write.csv(ref, output_file, row.names = FALSE, quote = FALSE)
  cat(sprintf("Reference file saved at: %s\n", output_file))
  
  # Return the results
  return(ref)
}


ref2 <- keyword_search2(dir_data)
