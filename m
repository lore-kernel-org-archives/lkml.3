Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbaGYIPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:15:32 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48879 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:15:29 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: DT: Clarify Xilinx Zynq platform
Date: Fri, 25 Jul 2014 10:15:18 +0200
Message-Id: <7153c8eded88751e7637f08f2bfe9cb6a65036e7.1406275971.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17748-1406276118-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17748-1406276118-0001

ep107 was emulation platform and compatible string
have been changed long time ago.

"ARM: zynq: dts: split up device tree"
(sha1: e06f1a9ed7ebff170ba05d2606d079fb36c6a52d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 Documentation/devicetree/bindings/arm/xilinx.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/xilinx.txt b/Documentation/devicetree/bindings/arm/xilinx.txt
index 6f1ed830b4f7..1f7995357888 100644
--- a/Documentation/devicetree/bindings/arm/xilinx.txt
+++ b/Documentation/devicetree/bindings/arm/xilinx.txt
@@ -1,7 +1,7 @@
-Xilinx Zynq EP107 Emulation Platform board
+Xilinx Zynq Platforms Device Tree Bindings

-This board is an emulation platform for the Zynq product which is
-based on an ARM Cortex A9 processor.
+Boards with Zynq-7000 SOC based on an ARM Cortex A9 processor
+shall have the following properties.

 Required root node properties:
-    - compatible = "xlnx,zynq-ep107";
+    - compatible = "xlnx,zynq-7000";
--
1.8.2.3


--=_mimegpg-monstr-desktop-17748-1406276118-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPSEhYACgkQykllyylKDCEtPwCfZ/gYyLnKoTWv6fVrUQ2R8zkk
NnEAn0zHHK8ptHZkSvFhb9/MbIOPmST6
=gqx3
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17748-1406276118-0001--
