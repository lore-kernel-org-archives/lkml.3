Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaIRTFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:05:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40715 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaIRTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:05:26 -0400
From: Nishanth Menon <nm@ti.com>
To: <lee.jones@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V3 1/3] Documentation: dt-bindings: mfd: palmas: Fix example style of i2c peripheral
Date: Thu, 18 Sep 2014 14:04:44 -0500
Message-ID: <1411067086-16613-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411067086-16613-1-git-send-email-nm@ti.com>
References: <1411067086-16613-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device@address as name for device nodes.

Suggested-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
V3: no change
V2: http://marc.info/?l=linux-kernel&m=140995036518562&w=2

 Documentation/devicetree/bindings/mfd/palmas.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index eda8989..d193859 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -33,7 +33,7 @@ Optional properties:
 
 Example:
 
-palmas {
+palmas@48 {
 	compatible = "ti,twl6035", "ti,palmas";
 	reg = <0x48>
 	interrupt-parent = <&intc>;
-- 
1.7.9.5

