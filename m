Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaJBKle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:41:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55357 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaJBKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:41:30 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jiri Kosina <trivial@kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] PCI: xilinx: Trivial fix in DT example
Date: Thu,  2 Oct 2014 12:41:19 +0200
Message-Id: <4a72f98ee8564b6b040d6301e2719e37ddfea663.1412246470.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12709-1412246479-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12709-1412246479-0001

Good to have it properly describe for c&p cases.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Based on linux-next. File should be in pci tree.
---
 Documentation/devicetree/bindings/pci/xilinx-pcie.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
index 3e2c88d97ad4..02f979a48aeb 100644
--- a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
@@ -58,5 +58,5 @@ Example:
 			interrupt-controller;
 			#address-cells = <0>;
 			#interrupt-cells = <1>;
-		}
+		};
 	};
--
1.8.2.3


--=_mimegpg-monstr-desktop-12709-1412246479-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQtK88ACgkQykllyylKDCFqOACfTpsYIRkVyNAasDNXG9oSm9XV
vV4AmQH/4k0Pz54vHyp+QkjfNNerZcuO
=I1Po
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12709-1412246479-0001--
