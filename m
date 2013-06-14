Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FNJoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:44:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56309 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3FNJoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:44:20 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <avinashphilip@ti.com>
Subject: [PATCH v2 1/4] ARM: davinci: da850: Use #include for all device trees
Date: Fri, 14 Jun 2013 15:15:53 +0530
Message-ID: <1371203156-15260-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace /include/ by #include for da850 device tree files, in order to
use the C pre-processor, making use of #define features possible.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v1:
	- New patch and comes as a dependency of patch 3/4

 arch/arm/boot/dts/da850-enbw-cmc.dts |    2 +-
 arch/arm/boot/dts/da850-evm.dts      |    2 +-
 arch/arm/boot/dts/da850.dtsi         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/da850-enbw-cmc.dts b/arch/arm/boot/dts/da850-enbw-cmc.dts
index 422fdb3..e750ab9 100644
--- a/arch/arm/boot/dts/da850-enbw-cmc.dts
+++ b/arch/arm/boot/dts/da850-enbw-cmc.dts
@@ -10,7 +10,7 @@
  * option) any later version.
  */
 /dts-v1/;
-/include/ "da850.dtsi"
+#include "da850.dtsi"
 
 / {
 	compatible = "enbw,cmc", "ti,da850";
diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c914357..5bce7cc 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -8,7 +8,7 @@
  * Free Software Foundation, version 2.
  */
 /dts-v1/;
-/include/ "da850.dtsi"
+#include "da850.dtsi"
 
 / {
 	compatible = "ti,da850-evm", "ti,da850";
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 452bdc6..3b66020 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -7,7 +7,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	arm {
-- 
1.7.9.5

