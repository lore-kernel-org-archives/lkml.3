Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaIQObG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:31:06 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62454 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbaIQObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:31:03 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] devicetree: cadence_ttc: Document binding for timer width
Date: Wed, 17 Sep 2014 16:30:49 +0200
Message-Id: <3537996136ec435ea660da869102d0a019214979.1410964243.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-29130-1410964250-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-29130-1410964250-0001

From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

Modern TTC implementations can extend the timer width to 32 bit. This
feature is not self identifying so the driver needs to be made aware
via device tree.

Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
index 993695c659e1..5439976eca6b 100644
--- a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
+++ b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
@@ -6,6 +6,9 @@ Required properties:
 - interrupts : A list of 3 interrupts; one per timer channel.
 - clocks: phandle to the source clock

+Optional properties:
+- timer-width: Bit width of the timer. Either 16 or 32 (default 16).
+
 Example:

 ttc0: ttc0@f8001000 {
@@ -14,4 +17,5 @@ ttc0: ttc0@f8001000 {
 	compatible = "cdns,ttc";
 	reg = <0xF8001000 0x1000>;
 	clocks = <&cpu_clk 3>;
+	timer-width = <32>;
 };
--
1.8.2.3


--=_mimegpg-monstr-desktop-29130-1410964250-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQZmxoACgkQykllyylKDCHAGwCfZr811zCZFGU1RuI2/BOONGt2
l8wAnjbLDyX117+Cv9/PkF/EXPAfgv8k
=o9Ek
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-29130-1410964250-0001--
