Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaCEIzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:55:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61833 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaCEIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:55:07 -0500
From: dt.tangr@gmail.com
To: devicetree@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, robh+dt@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter.Chen@freescale.com
Subject: [PATCHv2] devicetree: bindings: document lsi,zevio-usb
Date: Wed,  5 Mar 2014 19:54:46 +1100
Message-Id: <1394009686-17155-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
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
index 0000000..abbcb2a
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
+Optional properties:
+- vbus-supply: regulator for vbus
+
+Examples:
+		usb0: usb@b0000000 {
+			reg = <0xb0000000 0x1000>;
+			compatible = "lsi,zevio-usb";
+			interrupts = <8>;
+			vbus-supply = <&vbus_reg>;
+		};
-- 
1.7.10.4

