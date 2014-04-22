Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaDVJod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:44:33 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55110 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbaDVJoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:44:15 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Chen <Peter.Chen@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 1/3] usb: chipidea: msm: Add device tree binding information
Date: Tue, 22 Apr 2014 12:43:15 +0300
Message-Id: <1398159797-26917-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com>
References: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Document device tree binding information as required by
the Qualcomm USB controller.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt
new file mode 100644
index 0000000..7221072
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt
@@ -0,0 +1,17 @@
+Qualcomm CI13xxx (Chipidea) USB controllers
+
+Required properties:
+- compatible:   should contain "qcom,ci-hdrc"
+- reg:          offset and length of the register set in the memory map
+- interrupts:   interrupt-specifier for the controller interrupt.
+- usb-phy:      phandle for the PHY device
+- dr_mode:      Sould be "peripheral"
+
+Examples:
+	gadget@f9a55000 {
+		compatible = "qcom,ci-hdrc";
+		reg = <0xf9a55000 0x400>;
+		dr_mode = "peripheral";
+		interrupts = <0 134 0>;
+		usb-phy = <&usbphy0>;
+	};
--
1.8.3.2

