<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

Route::get('think', function () {
    return 'hello,ThinkPHP5!';
});

Route::any('login','index/index/login');
Route::any('getMenu','index/index/getMenu');
Route::any('enQrcode','admin/index/enQrcode');
Route::any('createOrder','index/index/createOrder');


Route::any('getOrder','index/index/getOrder');
Route::any('checkOrder','index/index/checkOrder');
Route::any('getState','index/index/getState');

Route::any('appHeart','index/index/appHeart');
Route::any('appPush','index/index/appPush');


Route::any('closeEndOrder','index/index/closeEndOrder');

Route::any('adminCheckUpdate','admin/Index/checkUpdate');
Route::any('adminGetMain','admin/Index/getMain');
Route::any('adminGetSettings','admin/Index/getSettings');
Route::any('adminSaveSetting','admin/Index/saveSetting');
Route::any('adminAddPayQrcode','admin/Index/addPayQrcode');
Route::any('adminGetPayQrcodes','admin/Index/getPayQrcodes');
Route::any('adminDelPayQrcode','admin/Index/delPayQrcode');
Route::any('adminGetOrders','admin/Index/getOrders');
Route::any('adminDelOrder','admin/Index/delOrder');
Route::any('adminSetBd','admin/Index/setBd');
Route::any('adminDelGqOrder','admin/Index/delGqOrder');
Route::any('adminDelLastOrder','admin/Index/delLastOrder');


return [

];
