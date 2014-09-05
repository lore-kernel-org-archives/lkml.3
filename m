Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaIEUwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:52:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55671 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaIEUwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:52:36 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH V2 1/3] Documentation: dt-bindings: mfd: palmas: Fix example style of i2c peripheral
Date: Fri, 5 Sep 2014 15:51:49 -0500
Message-ID: <1409950311-25236-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409950311-25236-1-git-send-email-nm@ti.com>
References: <1409950311-25236-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device@address as name for device nodes.

Suggested-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
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

