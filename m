Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbbAOMrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:47:35 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54027 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbAOMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:47:33 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: DT: Fix binding for cadence WDT
Date: Thu, 15 Jan 2015 13:47:29 +0100
Message-Id: <0c27264afa3356979d803d53d329458039f64485.1421326047.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-7207-1421326049-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-7207-1421326049-0001

Based on:
"devicetree: Add Cadence WDT devicetree bindings documentation"
(sha1: 191891c0378f44aec8e06e889a08d0b76fe6c5cb)

- compatible string is cdns,wdt-r1p2
- remove device_type property
- remove int reset property (reset-on-timeout is bool)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/boot/dts/zynq-7000.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index c9b9722c0c59..a5cd2eda3edf 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -342,12 +342,10 @@

 		watchdog0: watchdog@f8005000 {
 			clocks = <&clkc 45>;
-			compatible = "xlnx,zynq-wdt-r1p2";
-			device_type = "watchdog";
+			compatible = "cdns,wdt-r1p2";
 			interrupt-parent = <&intc>;
 			interrupts = <0 9 1>;
 			reg = <0xf8005000 0x1000>;
-			reset = <0>;
 			timeout-sec = <10>;
 		};
 	};
--
1.8.2.3


--=_mimegpg-monstr-desktop-7207-1421326049-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS3tuEACgkQykllyylKDCHZcwCfbca+f5CtcIBKR5Ml7Ozw3eTS
WbwAni6isv7kkYFdDRk1TGGnxGjjQqOi
=8C/M
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-7207-1421326049-0001--
