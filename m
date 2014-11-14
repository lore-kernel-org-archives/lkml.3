Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaKNJWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:22:09 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50913 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaKNJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:22:05 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Remove secondary_startup() declaration from header
Date: Fri, 14 Nov 2014 10:21:53 +0100
Message-Id: <f8646bfc1a5c6bd86103cc237dca2dec2ca9efa6.1415956908.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17634-1415956913-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17634-1415956913-0001

secondary_startup() in the header is not needed at all.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 2bc71273c73c..382c60e9aa16 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -29,7 +29,6 @@ extern void zynq_slcr_cpu_state_write(int cpu, bool die);
 extern u32 zynq_slcr_get_device_id(void);

 #ifdef CONFIG_SMP
-extern void secondary_startup(void);
 extern char zynq_secondary_trampoline;
 extern char zynq_secondary_trampoline_jump;
 extern char zynq_secondary_trampoline_end;
--
1.8.2.3


--=_mimegpg-monstr-desktop-17634-1415956913-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlRlybEACgkQykllyylKDCFK2ACgmUdier+z6c9fFXdqnHuODWYo
iwcAnidm7BPL30YUQ7nRstq3kpmGvv8Y
=a90V
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17634-1415956913-0001--
