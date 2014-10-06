Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaJFMiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:38:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49273 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJFMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:38:15 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] ARM: zynq: DT: Add OCM controller node
Date: Mon,  6 Oct 2014 14:38:07 +0200
Message-Id: <1b10d4e509caac663966788cd2df10120496eb1e.1412599051.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
References: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
In-Reply-To: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
References: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17186-1412599090-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17186-1412599090-0001

Add the on-chip-memory controller node to the Zynq devicetree.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v3:
- Extract from OCM driver

Changes in v2: None

 arch/arm/boot/dts/zynq-7000.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 6cc83d4c6c76..b8e87d615635 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -146,6 +146,13 @@
 			cache-level = <2>;
 		};

+		ocmc: ocmc@f800c000 {
+			compatible = "xlnx,zynq-ocmc-1.0";
+			interrupt-parent = <&intc>;
+			interrupts = <0 3 4>;
+			reg = <0xf800c000 0x1000>;
+		} ;
+
 		uart0: serial@e0000000 {
 			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
 			status = "disabled";
--
1.8.2.3


--=_mimegpg-monstr-desktop-17186-1412599090-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQyjTIACgkQykllyylKDCEO0wCfb3pcue06wc/LpNBSwNGWuqkR
D/YAnjdh68ekd4vxp4XtZmirRozDeoru
=SrVT
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17186-1412599090-0001--
