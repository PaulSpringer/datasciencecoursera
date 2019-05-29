## A pair of functions that cache the inverse of a matrix. It is especially
## helpful for large matrices which are calculated in a loop and serves to 
## save computational costs.
## Calling the functions must be of the form/order such that
## cacheSolve(makeCacheMatrix(M)), where M is matrix of your choise

## This function creates a special "matrix" object that can cache its inverse.

makeCacheMatrix <- function(x = matrix()) {
        Inv <- NULL
        set <- function (y){
                x <<- y
                Inv <<- NULL
        }
        
        get <- function() x
        
        setinverse <- function(Inversed_mat) Inv <<- Inversed_mat
        
        getinverse <- function() Inv
        
        list(set = set, get = get, setinverse = setinverse,
             getinverse = getinverse)

}


## This function computes the inverse of the special "matrix" returned by
## makeCacheMatrix above. If the inverse has already been calculated (and the
## matrix has not changed), then the cacheSolve retrieves the inverse from
## the cache.

cacheSolve <- function(makeCacheMatrix.object, ...) {
        ## Return a matrix that is the inverse of 'x'
        Inv.local <- makeCacheMatrix.object$getinverse()
        if(!is.null(Inv.local)) {
                message("getting cached data")
                return(Inv.local)
        }
        data <- makeCacheMatrix.object$get()
        Inv.local.calculated <- solve(data, ...)
        makeCacheMatrix.object$setinverse(Inv.local.calculated)
        Inv.local.calculated # return calculated inverted matrix
}
