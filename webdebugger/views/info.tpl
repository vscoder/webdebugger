URI PATH {{path}}

<br>
ENVIRON
<br>
<table>
<thead>
<tr><td>key</td><td>value</td></tr>
</thead>
<tbody>
% for k, v in environ.items():
    <tr><td>{{ k }}</td><td>{{ v }}</td></tr>
% end
</tbody>
</table>

<br>
HEADERS
<br>
<table>
<thead>
<tr><td>key</td><td>value</td></tr>
</thead>
<tbody>
% for k, v in headers.items():
    <tr><td>{{ k }}</td><td>{{ v }}</td></tr>
% end
</tbody>
</table>
