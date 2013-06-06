Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3FFFmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:42:18 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55645 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3FFFls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:41:48 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 1/2] ARM: dts: bcm281xx: use #include for device tree files
Date: Thu,  6 Jun 2013 01:41:34 -0400
Message-Id: <1370497295-12682-2-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
References: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace /include/ by #include for bcm281xx device tree
files, enabling use of the C preprocessor.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351-brt.dts |    2 +-
 arch/arm/boot/dts/bcm11351.dtsi    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 248067c..3392f64 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -13,7 +13,7 @@
 
 /dts-v1/;
 
-/include/ "bcm11351.dtsi"
+#include "bcm11351.dtsi"
 
 / {
 	model = "BCM11351 BRT board";
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 41b2c6c..c08810e 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -11,7 +11,7 @@
  * GNU General Public License for more details.
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	model = "BCM11351 SoC";
-- 
1.7.9.5

