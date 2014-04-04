Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaDDWAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:00:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50812 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaDDWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:00:40 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 1/2] ARM: zynq: dt: Convert to preprocessor includes
Date: Fri,  4 Apr 2014 15:00:30 -0700
Message-Id: <1396648831-7570-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all Zynq DT files to the dtc preprocessor include syntax.
This allows to include header files in the devicetrees like other
SoC-types already do.

Inspired-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
(http://www.spinics.net/lists/arm-kernel/msg319832.html)

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 arch/arm/boot/dts/zynq-7000.dtsi | 3 ++-
 arch/arm/boot/dts/zynq-zc702.dts | 2 +-
 arch/arm/boot/dts/zynq-zc706.dts | 2 +-
 arch/arm/boot/dts/zynq-zed.dts   | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 789d0bacc110..b028278b7f49 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -10,7 +10,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-/include/ "skeleton.dtsi"
+
+#include "skeleton.dtsi"
 
 / {
 	compatible = "xlnx,zynq-7000";
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index c913f77a21eb..07713d3c716a 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -12,7 +12,7 @@
  * GNU General Public License for more details.
  */
 /dts-v1/;
-/include/ "zynq-7000.dtsi"
+#include "zynq-7000.dtsi"
 
 / {
 	model = "Zynq ZC702 Development Board";
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 88f62c50382e..cf6566cdb02a 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -13,7 +13,7 @@
  * GNU General Public License for more details.
  */
 /dts-v1/;
-/include/ "zynq-7000.dtsi"
+#include "zynq-7000.dtsi"
 
 / {
 	model = "Zynq ZC706 Development Board";
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index 82d7ef1a9a9c..1541716e2cfb 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -13,7 +13,7 @@
  * GNU General Public License for more details.
  */
 /dts-v1/;
-/include/ "zynq-7000.dtsi"
+#include "zynq-7000.dtsi"
 
 / {
 	model = "Zynq Zed Development Board";
-- 
1.9.1.1.gbb9f595

