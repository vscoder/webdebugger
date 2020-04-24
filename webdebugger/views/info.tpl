<div>
    <h2>Request environment</h2>
    <br>
    <table>
        <thead>
            <tr>
                <td>key</td>
                <td>value</td>
            </tr>
        </thead>
        <tbody>
            % for k, v in bottle_env.items():
            <tr>
                <td>{{ k }}</td>
                <td>{{ v }}</td>
            </tr>
            % end
        </tbody>
    </table>
</div>
<div>
    <h2>
        OS environment
    </h2>
    <table>
        <thead>
            <tr>
                <td>key</td>
                <td>value</td>
            </tr>
        </thead>
        <tbody>
            % for k, v in os_env.items():
            <tr>
                <td>{{ k }}</td>
                <td>{{ v }}</td>
            </tr>
            % end
        </tbody>
    </table>
</div>
