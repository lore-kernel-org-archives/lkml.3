Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaAaOTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:19:14 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51999 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaAaOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:18:55 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/10] watchdog: xilinx: Use correct comment indentation
Date: Fri, 31 Jan 2014 15:18:17 +0100
Message-Id: <45680208de6e22a49fe8311d49877096ccd702af.1391177880.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23161-1391177930-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23161-1391177930-0001

No functional changes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/watchdog/of_xilinx_wdt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 475440a6..7948def 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -190,10 +190,10 @@ static int xwdt_probe(struct platform_device *pdev)
 		watchdog_set_nowayout(xilinx_wdt_wdd, true);
 	}

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


--=_mimegpg-monstr-desktop-23161-1391177930-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrsMoACgkQykllyylKDCHXqACcCPeU4YUtCh3D0Y2JtbCZu+Sb
Ua0An2fd/Jm4GHhRWlSlIbEyeuSUzpX8
=5rkm
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23161-1391177930-0001--
