import javascript

from File f
where f.getAbsolutePath().matches("%vulnerable-project%")
select f.getNumberOfLines(), f
