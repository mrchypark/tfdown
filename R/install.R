download_url <- function(backend, os, arch, ver) {
  backend <- match.arg(backend, c("cpu", "gpu"))
  os <- match.arg(os, c("linux", "darwin", "windows"))
  arch <- match.arg(arch, c("x86_64"))
  vchk <- try(semver::parse_version(ver), silent = T)
  if (inherits(vchk, "try-error")) {
    stop(paste0("Invaled semver syntex: ", ver))
  }
  ext <- ifelse(os == "windows", "zip", "tar.gz")
  paste0(
    "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-",
    backend,
    "-",
    os,
    "-",
    arch,
    "-",
    ver
    ,
    ".",
    ext
  )
}

install_path <- function(version = "2.9.1") {
  path <- Sys.getenv("TF_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(file.path(system.file("", package = "tfdown")), mustWork = FALSE)
  }
}

#' A simple exported version of install_path
#' Returns the tensorflow installation path.
#' @export
tf_install_path <- function() {
  install_path()
}

install_exists <- function() {
  if (!dir.exists(install_path())) {
    return(FALSE)
  }

  if (!length(list.files(file.path(install_path(), "lib"), "tfdown")) > 0) {
    return(FALSE)
  }

  TRUE
}

#' Verifies if tensorflow is installed
#'
#' @export
tf_is_installed <- function() {
  install_exists()
}

install_os <- function() {
  tolower(Sys.info()[["sysname"]])
}

install_tensorflow <- function() {
  library_url <- download_url("cpu", "windows", "x86_64", "2.9.1")
  library_extension <- paste0(".", tools::file_ext(library_url))
  temp_file <- tempfile(fileext = library_extension)
  temp_path <- tempfile()

  utils::download.file(library_url, temp_file, mode = "wb")
  on.exit(try(unlink(temp_file))
  )

  unc <-
    if (identical(library_extension, ".zip"))
      utils::unzip
  else
    utils::untar
  unc(temp_file, exdir = temp_path)

  file.copy(
    from = dir(file.path(temp_path, source_path), full.names = TRUE),
    to = file.path(install_path, inst_path),
    recursive = TRUE
  )
}
