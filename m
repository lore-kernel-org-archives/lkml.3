Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbbAOMm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:42:56 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35654 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbbAOMmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:42:54 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: Remove .owner field from cadence driver
Date: Thu, 15 Jan 2015 13:42:41 +0100
Message-Id: <204239650e5bf19ea11cb4b9f41937552324e931.1421325759.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-6879-1421325761-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-6879-1421325761-0001

.owner files is filled by module_platform_driver().

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Big cleanup was done and this new driver was missed.
---
 drivers/watchdog/cadence_wdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/cadence_wdt.c b/drivers/watchdog/cadence_wdt.c
index 5927c0a98a74..bcfd2a22208f 100644
--- a/drivers/watchdog/cadence_wdt.c
+++ b/drivers/watchdog/cadence_wdt.c
@@ -503,7 +503,6 @@ static struct platform_driver cdns_wdt_driver = {
 	.shutdown	= cdns_wdt_shutdown,
 	.driver		= {
 		.name	= "cdns-wdt",
-		.owner	= THIS_MODULE,
 		.of_match_table = cdns_wdt_of_match,
 		.pm	= &cdns_wdt_pm_ops,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-6879-1421325761-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS3tcEACgkQykllyylKDCHuvQCfZ7Q3sjtx9ibYAyccgf/PsWbs
TmQAnAjMMxA57OWGrdWXcTfGU4nHWp7x
=McdT
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-6879-1421325761-0001--
