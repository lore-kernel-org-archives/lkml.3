Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaIWSz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:55:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44598 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIWSz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:55:26 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] ARM: zynq: DT: Remove 222 MHz OPP
Date: Tue, 23 Sep 2014 11:55:20 -0700
Message-Id: <1411498520-8117-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to dependencies between timer and CPU frequency, only changes by
powers of two are allowed. The clocksource driver prevents other
changes, but with cpufreq and its governors it can result in being
spammed with error messages constantly. Hence, remove the 222 MHz OPP.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 6cc83d4c6c76..a0ed01d68328 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -30,7 +30,6 @@
 				/* kHz    uV */
 				666667  1000000
 				333334  1000000
-				222223  1000000
 			>;
 		};
 
-- 
2.1.0.1.g27b9230

