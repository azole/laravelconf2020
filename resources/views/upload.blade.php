<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    </head>
    <body>
        <div class="container">
            <div class="panel panel-primary">
                <div class="panel-heading"><h2>我是一個網站</h2></div>
                <div class="panel-body">
             
                  @if ($message = Session::get('success'))
                  <div class="alert alert-success alert-block">
                      <button type="button" class="close" data-dismiss="alert">×</button>
                          <strong>{{ $message }}</strong>
                  </div>
                  <img src="{{ Session::get('image') }}">
                  @endif
            
                  @if (count($errors) > 0)
                      <div class="alert alert-danger">
                          <strong>Whoops!</strong> There were some problems with your input.
                          <ul>
                              @foreach ($errors->all() as $error)
                                  <li>{{ $error }}</li>
                              @endforeach
                          </ul>
                      </div>
                  @endif
            
                  <form action="{{ route('image.upload.post') }}" method="POST" enctype="multipart/form-data">
                      @csrf
                      <div class="row">
            
                          <div class="col-md-6">
                              <input type="file" name="image" class="form-control">
                          </div>
             
                          <div class="col-md-6">
                              <button type="submit" class="btn btn-success">Upload</button>
                          </div>
             
                      </div>
                  </form>
            
                </div>
            </div>
        </div>
    </body>
</html>
