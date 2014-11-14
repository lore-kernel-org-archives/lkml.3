Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272AbaKNKwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:52:31 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33260 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144AbaKNKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:52:28 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
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
Subject: [PATCH v4 6/6] ARM: zynq: DT: Add OCM controller node
Date: Fri, 14 Nov 2014 11:52:07 +0100
Message-Id: <0a88d52b5e71fb220ca619180ec9ca746edad2b1.1415962281.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1415962281.git.michal.simek@xilinx.com>
References: <cover.1415962281.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1415962281.git.michal.simek@xilinx.com>
References: <cover.1415962281.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-14140-1415962343-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-14140-1415962343-0001

Add the on-chip-memory controller node to the Zynq devicetree.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v4:
- Use memory-controller@... instead of ocmc@...

Changes in v3:
- Extract from OCM driver

Changes in v2: None

 arch/arm/boot/dts/zynq-7000.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ce2ef5bec4f2..e217fb1c1169 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -150,6 +150,13 @@
 			reg = <0xf8006000 0x1000>;
 		};

+		ocmc: memory-controller@f800c000 {
+			compatible = "xlnx,zynq-ocmc-1.0";
+			interrupt-parent = <&intc>;
+			interrupts = <0 3 4>;
+			reg = <0xf800c000 0x1000>;
+		};
+
 		uart0: serial@e0000000 {
 			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
 			status = "disabled";
--
1.8.2.3


--=_mimegpg-monstr-desktop-14140-1415962343-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlRl3ucACgkQykllyylKDCEBmACeONWnKUPesJOfiLYv5yzZV0WP
SaIAn0ySSoFmfvjhQTgcAvw+HVGmpr2j
=otbC
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-14140-1415962343-0001--
