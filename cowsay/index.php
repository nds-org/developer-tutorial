<!DOCTYPE html>
<html>
<body>

<h2>Cowsay</h2>

<?php
echo "<pre>";
echo `/usr/games/fortune -a | /usr/games/cowsay`;
echo "</pre>";
?>

</body>
</html>
