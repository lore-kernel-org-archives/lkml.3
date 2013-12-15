Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3LODfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:35:44 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50277 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:35:41 -0500
From: dt.tangr@gmail.com
To: linux-usb@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 3/3] devicetree: bindings: document lsi,zevio-usb
Date: Sun, 15 Dec 2013 14:35:09 +1100
Message-Id: <1387078509-14156-3-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
References: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../devicetree/bindings/usb/ci-hdrc-zevio.txt         |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
new file mode 100644
index 0000000..1a005eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
@@ -0,0 +1,17 @@
+* LSI Zevio USB OTG Controller
+
+Required properties:
+- compatible: Should be "lsi,zevio-usb"
+- reg: Should contain registers location and length
+- interrupts: Should contain controller interrupt
+
+Recommended properies:
+- vbus-supply: regulator for vbus
+
+Examples:
+		usb0: usb@B0000000 {
+			reg = <0xB0000000 0x1000>;
+			compatible = "lsi,zevio-usb";
+			interrupts = <8>;
+			vbus-supply = <&vbus_reg>;
+		};
-- 
1.7.10.4

