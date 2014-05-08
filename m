Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaEHPNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:13:51 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58937 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaEHPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:13:49 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: git@xilinx.com, monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: zynq: Sort Kconfig options
Date: Thu,  8 May 2014 17:13:37 +0200
Message-Id: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-676-1399562019-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-676-1399562019-0001

Keep options sorted.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 58c2b844e0a3..1daa5c220d1d 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -1,14 +1,15 @@
 config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
-	select ARM_AMBA
-	select ARM_GIC
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select ARM_AMBA
+	select ARM_GIC
+	select ARM_GLOBAL_TIMER if !CPU_FREQ
+	select CADENCE_TTC_TIMER
+	select GENERIC_ALLOCATOR
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select ICST
-	select CADENCE_TTC_TIMER
-	select ARM_GLOBAL_TIMER if !CPU_FREQ
 	select MFD_SYSCON
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
--
1.8.2.3


--=_mimegpg-monstr-desktop-676-1399562019-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNrnyMACgkQykllyylKDCEyvgCgjlruFX5LlOSRE+4KLD58ct2n
jjAAnRnpmr+0F6C4v+wGjEBHpF8S5dht
=vFOf
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-676-1399562019-0001--
