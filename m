Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbbAOHtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:49:04 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47412 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbAOHtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:49:02 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Setup default gpio number for Xilinx Zynq
Date: Thu, 15 Jan 2015 08:48:55 +0100
Message-Id: <a6813ce56fdabddb69a4b1e99e3b10bdb03ac7b1.1421308133.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-6451-1421308135-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-6451-1421308135-0001

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed60a0b..da77f786f99f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1488,7 +1488,7 @@ config ARM_PSCI
 # selected platforms.
 config ARCH_NR_GPIO
 	int
-	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
+	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA || ARCH_ZYNQ
 	default 512 if ARCH_EXYNOS || ARCH_KEYSTONE || SOC_OMAP5 || \
 		SOC_DRA7XX || ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
 	default 416 if ARCH_SUNXI
--
1.8.2.3


--=_mimegpg-monstr-desktop-6451-1421308135-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS3cOcACgkQykllyylKDCHr3gCfUtnlJqTcRybhhbr7GU+xm3nu
cQUAoIMdJ/2j1QV1vdwiCCd3DslnsGPw
=KISy
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-6451-1421308135-0001--
