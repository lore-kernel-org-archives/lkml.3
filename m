Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3KKNoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:44:10 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54329 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3KKNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:43:43 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: alexander.shishkin@linux.intel.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/4] usb: chipidea: msm: Add device tree binding information
Date: Mon, 11 Nov 2013 15:35:34 +0200
Message-Id: <1384176937-1658-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 5ea26c6..0a85eba 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -15,3 +15,19 @@ Example EHCI controller device node:
 		usb-phy = <&usb_otg>;
 	};
 
+CI13xxx (Chipidea) USB controllers
+
+Required properties:
+- compatible: 	should contain "qcom,ci-hdrc"
+- reg: 			offset and length of the register set in the memory map
+- interrupts: 	interrupt-specifier for the controller interrupt.
+- usb-phy:		phandle for the PHY device
+- dr_mode: 		Sould be "peripheral"
+
+	gadget@f9a55000 {
+		compatible = "qcom,ci-hdrc";
+		reg = <0xf9a55000 0x400>;
+		dr_mode = "peripheral";
+		interrupts = <0 134 0>;
+		usb-phy = <&usb_otg>;
+	};
\ No newline at end of file
-- 
1.7.9.5

