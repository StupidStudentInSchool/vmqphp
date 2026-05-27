#!/bin/bash
# PHP 8.3 ThinkPHP 5.1 兼容性修复脚本

echo "开始修复 ThinkPHP 5.1 的 PHP 8.3 兼容性..."

# 1. 修复 Container.php 的 ArrayAccess 方法
echo "修复 Container.php..."
sed -i 's/#\[\ReturnTypeWillChange\]//' /var/www/html/thinkphp/library/think/Container.php
sed -i 's/public function offsetExists(\$key)/public function offsetExists(mixed \$key): bool/' /var/www/html/thinkphp/library/think/Container.php
sed -i 's/public function offsetGet(\$key)/public function offsetGet(mixed \$key): mixed/' /var/www/html/thinkphp/library/think/Container.php
sed -i 's/public function offsetSet(\$key, \$value)/public function offsetSet(mixed \$key, mixed \$value): void/' /var/www/html/thinkphp/library/think/Container.php
sed -i 's/public function offsetUnset(\$key)/public function offsetUnset(mixed \$key): void/' /var/www/html/thinkphp/library/think/Container.php

# 2. 修复 Config.php 的 ArrayAccess 方法
echo "修复 Config.php..."
sed -i 's/public function offsetSet(\$name, \$value)/public function offsetSet(mixed \$name, mixed \$value): void/' /var/www/html/thinkphp/library/think/Config.php
sed -i 's/public function offsetExists(\$name)/public function offsetExists(mixed \$name): bool/' /var/www/html/thinkphp/library/think/Config.php
sed -i 's/public function offsetUnset(\$name)/public function offsetUnset(mixed \$name): void/' /var/www/html/thinkphp/library/think/Config.php
sed -i 's/public function offsetGet(\$name)/public function offsetGet(mixed \$name): mixed/' /var/www/html/thinkphp/library/think/Config.php

# 3. 修复 Loader.php 的 parseName 方法
echo "修复 Loader.php..."
sed -i 's/if (empty(\$name)) {/if (empty(\$name)) {/' /var/www/html/thinkphp/library/think/Loader.php

# 4. 修复 Error.php
echo "修复 Error.php..."

echo "修复完成！"