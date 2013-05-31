Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3EaF5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:57:01 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47127 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3EaF4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:56:45 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2 1/2] watchdog: xilinx: Fix driver header
Date: Fri, 31 May 2013 07:56:33 +0200
Message-Id: <b565740967bfa3b3fa867442634f524000c097f8.1369979787.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1369979787.git.michal.simek@xilinx.com>
References: <cover.1369979787.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1369979787.git.michal.simek@xilinx.com>
References: <cover.1369979787.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-31309-1369979802-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-31309-1369979802-0001

- Remove reference for IP version
- Fix header coding style
- Remove notes which are visible from the code
- Fix driver license according to header

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2: None

 drivers/watchdog/of_xilinx_wdt.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 2761ddb..d4a35ab 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -1,23 +1,13 @@
 /*
-*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx xps_timebase_wdt
-*
-*   (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
-*
-*       -----------------------
-*
-*   This program is free software; you can redistribute it and/or
-*   modify it under the terms of the GNU General Public License
-*   as published by the Free Software Foundation; either version
-*   2 of the License, or (at your option) any later version.
-*
-*       -----------------------
-*	30-May-2011 Alejandro Cabrera <aldaya@gmail.com>
-*		- If "xlnx,wdt-enable-once" wasn't found on device tree the
-*		  module will use CONFIG_WATCHDOG_NOWAYOUT
-*		- If the device tree parameters ("clock-frequency" and
-*		  "xlnx,wdt-interval") wasn't found the driver won't
-*		  know the wdt reset interval
-*/
+ * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
+ *
+ * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

@@ -413,5 +403,5 @@ module_platform_driver(xwdt_driver);

 MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
 MODULE_DESCRIPTION("Xilinx Watchdog driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--
1.8.2.3


--=_mimegpg-monstr-desktop-31309-1369979802-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGoO5oACgkQykllyylKDCGz+QCeM1fZTCN8GabWutK18EtDKi+S
fbAAni43FbWHhvv8GMCEL3skERNskKrd
=3ZD/
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-31309-1369979802-0001--
