Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaLANZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:25:21 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61005 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaLANZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:17 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/7] devicetree: bindings: Add zynq ocmc node description
Date: Mon,  1 Dec 2014 14:24:56 +0100
Message-Id: <a408c70d8ce54e47e1b400dc2523b7886bf7fcef.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3305-1417440312-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3305-1417440312-0001

Add binding for Zynq On Chip Memory controller driver
which is taking care about On Chip Memory.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---

Changes in v5:
- Separate binding from the driver

Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt     | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt

diff --git a/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt
new file mode 100644
index 000000000000..dcf221e8a16e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt
@@ -0,0 +1,17 @@
+Device tree bindings for Zynq's OCM controller
+
+The OCM is divided to 4 64kB segments which can be separately configured
+to low or high location. Location is controlled via SLCR.
+
+Required properties:
+ compatible: Compatibility string. Must be "xlnx,zynq-ocmc-1.0".
+ reg: Specify the base and size of the OCMC registers in the memory map.
+      E.g.: reg = <0xf800c000 0x1000>;
+
+Example:
+ocmc: memory-controller@f800c000 {
+	compatible =  "xlnx,zynq-ocmc-1.0";
+	interrupt-parent = <&intc>;
+	interrupts = <0 3 4>;
+	reg = <0xf800c000 0x1000>;
+};
--
1.8.2.3


--=_mimegpg-monstr-desktop-3305-1417440312-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bDgACgkQykllyylKDCGGvgCfV94wcgB9JbiKDtUca023EeJA
W14AmgKRNbzwEfyn6wVaH4n/XvmKTkQt
=yTST
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3305-1417440312-0001--
