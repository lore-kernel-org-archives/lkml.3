Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3E3M02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:26:28 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45161 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3E3M0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:26:16 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 2/3] watchdog: xilinx: Setup the origin compatible string
Date: Thu, 30 May 2013 14:26:03 +0200
Message-Id: <eef4939944768b2d8cbed2bcb4cf75954b86fc27.1369916757.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
In-Reply-To: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8721-1369916773-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8721-1369916773-0001

Watchdog 1.01.a is also compatible with 1.00.a.
Setup the origin version to compatible list.
If you want to use newer watchdog version, please
extend your compatible list.

For example:
compatible = "xlnx,xps-timebase-wdt-1.02.a", "xlnx,xps-timebase-wdt-1.00.a";

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/watchdog/of_xilinx_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index d4a35ab..79f358c 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -384,7 +384,7 @@ static int xwdt_remove(struct platform_device *dev)

 /* Match table for of_platform binding */
 static struct of_device_id xwdt_of_match[] = {
-	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
+	{ .compatible = "xlnx,xps-timebase-wdt-1.00.a", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, xwdt_of_match);
--
1.8.2.3


--=_mimegpg-monstr-desktop-8721-1369916773-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnRWUACgkQykllyylKDCEqHwCcDVjl7A+2gdeHhQxfZlJ3rn3L
R7gAoJr5QvYJFLp6llX245thfGPtR/f+
=qNs8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8721-1369916773-0001--
