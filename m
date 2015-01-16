Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbbAPNAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:00:18 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53536 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbbAPNAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:00:15 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH] spi: Kconfig: Remove additional newline
Date: Fri, 16 Jan 2015 14:00:11 +0100
Message-Id: <05f726669457897c9d926e4c395ffaf08cd974f6.1421413208.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-28812-1421413211-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-28812-1421413211-0001

Trivial fix.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/spi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 99829985c1a1..2350efe997ec 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -595,7 +595,6 @@ config SPI_XTENSA_XTFPGA
 	  16 bit words in SPI mode 0, automatically asserting CS on transfer
 	  start and deasserting on end.

-
 config SPI_NUC900
 	tristate "Nuvoton NUC900 series SPI"
 	depends on ARCH_W90X900
--
1.8.2.3


--=_mimegpg-monstr-desktop-28812-1421413211-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS5C1sACgkQykllyylKDCHR4wCfV+MZQQ5ZnC2Lxd3nJnVM9jAv
NKYAnRKeEBnpREUenapyrMDouio0zw/P
=6ulS
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-28812-1421413211-0001--
