Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaBKG4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:56:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41660 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaBKG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:20 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 08/11] watchdog: xilinx: Use correct comment indentation
Date: Tue, 11 Feb 2014 07:55:51 +0100
Message-Id: <12517c3d533eeec7f57e9b9a67c851e39abeb32e.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9571-1392101776-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9571-1392101776-0001

No functional changes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v2: None

 drivers/watchdog/of_xilinx_wdt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index bb03e5b..dad8fb5 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -191,10 +191,10 @@ static int xwdt_probe(struct platform_device *pdev)
 	if (enable_once)
 		watchdog_set_nowayout(xilinx_wdt_wdd, true);

-/*
- *  Twice of the 2^wdt_interval / freq  because the first wdt overflow is
- *  ignored (interrupt), reset is only generated at second wdt overflow
- */
+	/*
+	 * Twice of the 2^wdt_interval / freq  because the first wdt overflow is
+	 * ignored (interrupt), reset is only generated at second wdt overflow
+	 */
 	if (!no_timeout)
 		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
 					  pfreq);
--
1.8.2.3


--=_mimegpg-monstr-desktop-9571-1392101776-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yZAACgkQykllyylKDCG0/gCfSPtRK+J8e1Bs8RWjU2vbsa0b
baMAn0hceNPz8J4OHA+mdtCu+EQNS17G
=nHMt
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9571-1392101776-0001--
