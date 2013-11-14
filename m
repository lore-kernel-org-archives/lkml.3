Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3KNTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:11:24 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2788 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3KNTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:11:08 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v3 3/8] Documentation: dt: kona-sdhci: Add clocks
 property
Date: Thu, 14 Nov 2013 11:10:38 -0800
Message-ID: <1384456243-27053-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
References: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E9BFF981SC8091015-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kona SDHCI block requires a clock that must be specified in the
device tree.  Update the documentation to reflect this requirement.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/mmc/kona-sdhci.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/kona-sdhci.txt b/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
index 789fb07..42a57c6 100644
--- a/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
@@ -6,12 +6,17 @@ and the properties present in the bcm281xx SDHCI
 Required properties:
 - compatible : Should be "brcm,kona-sdhci"
 - DEPRECATED: compatible : Should be "bcm,kona-sdhci"
+- clocks: clock specifier for the kona i2c external clock
+
+Refer to clocks/clock-bindings.txt for generic clock consumer
+properties.
 
 Example:
 
 sdio2: sdio@0x3f1a0000 {
 	compatible = "brcm,kona-sdhci";
 	reg = <0x3f1a0000 0x10000>;
+	clocks = <&sdio3_clk>;
 	interrupts = <0x0 74 0x4>;
 };
 
-- 
1.8.0.1


