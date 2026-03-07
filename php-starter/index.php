<?php
/**
 * Orbit Lab — PHP Starter
 *
 * Front controller. All requests that don't match a static file are routed here
 * via .htaccess. Replace this with your own application logic.
 */

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Starter — Orbit Lab</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #0a0a0a;
            color: #e5e5e5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 600px;
            width: 100%;
            padding: 3rem 2rem;
            text-align: center;
        }
        .logo {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }
        .subtitle {
            color: #a3a3a3;
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
        }
        .info {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: left;
        }
        .info h2 {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #737373;
            margin-bottom: 1rem;
        }
        .row {
            display: flex;
            justify-content: space-between;
            padding: 0.6rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            font-size: 0.9rem;
        }
        .row:last-child { border-bottom: none; }
        .row .label { color: #a3a3a3; }
        .row .value { color: #e5e5e5; font-family: monospace; font-size: 0.85rem; }
        .hint {
            margin-top: 2rem;
            color: #737373;
            font-size: 0.85rem;
            line-height: 1.6;
        }
        .hint code {
            background: rgba(255,255,255,0.1);
            padding: 0.15em 0.4em;
            border-radius: 4px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Orbit Lab</div>
        <p class="subtitle">PHP Starter</p>

        <div class="info">
            <h2>Server Info</h2>
            <div class="row">
                <span class="label">PHP</span>
                <span class="value"><?= phpversion() ?></span>
            </div>
            <div class="row">
                <span class="label">Server API</span>
                <span class="value"><?= php_sapi_name() ?></span>
            </div>
            <div class="row">
                <span class="label">OS</span>
                <span class="value"><?= PHP_OS ?></span>
            </div>
            <div class="row">
                <span class="label">Request</span>
                <span class="value"><?= htmlspecialchars($method . ' ' . $uri) ?></span>
            </div>
            <div class="row">
                <span class="label">Time</span>
                <span class="value"><?= date('Y-m-d H:i:s T') ?></span>
            </div>
        </div>

        <p class="hint">
            Edit <code>index.php</code> to build your app.<br>
            All requests route here via <code>.htaccess</code>.<br>
            Upload files with SFTP from your dashboard.
        </p>
    </div>
</body>
</html>
