Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaJTNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:25:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52345 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaJTNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:25:47 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ARM: zynq: Enable generic allocator
Date: Mon, 20 Oct 2014 15:25:32 +0200
Message-Id: <e5623273ff5d730b54c0c7dfe306dfbb98d4f058.1413811526.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
In-Reply-To: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23020-1413811543-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23020-1413811543-0001

Enable generic allocator by default because it is used by OCMC driver.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2: None

 arch/arm/mach-zynq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index aaa5162c1509..d447adefd397 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -5,6 +5,7 @@ config ARCH_ZYNQ
 	select ARM_GIC
 	select ARM_GLOBAL_TIMER if !CPU_FREQ
 	select CADENCE_TTC_TIMER
+	select GENERIC_ALLOCATOR
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select ICST
--
1.8.2.3


--=_mimegpg-monstr-desktop-23020-1413811543-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlRFDVcACgkQykllyylKDCFwigCfbha7WWn9OCJE6il9OOrYqIUW
+a8AoIWaLGIursOo9sCxD4mOvoFThN2L
=+8A9
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23020-1413811543-0001--
