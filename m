Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbbA0MSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499AbbA0MSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lokesh Vutla <lokeshvutla@ti.com>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 047/126] ARM: dts: DRA7: wdt: Fix compatible property for watchdog node
Date: Tue, 27 Jan 2015 12:15:52 +0000
Message-Id: <1422361031-19364-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lokesh Vutla <lokeshvutla@ti.com>

commit be6688350a4470e417aaeca54d162652aab40ac5 upstream.

OMAP wdt driver supports only ti,omap3-wdt compatible. In DRA7 dt
wdt compatible property is defined as ti,omap4-wdt by mistake instead of
ti,omap3-wdt. Correcting the typo.

Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/dra7.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index f21ef396902f..e46073edcfd4 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -452,7 +452,7 @@
 		};
 
 		wdt2: wdt@4ae14000 {
-			compatible = "ti,omap4-wdt";
+			compatible = "ti,omap3-wdt";
 			reg = <0x4ae14000 0x80>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "wd_timer2";
-- 
2.1.4

