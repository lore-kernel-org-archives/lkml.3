Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbbANHa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:30:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbANHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:30:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lokesh Vutla <lokeshvutla@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 119/150] ARM: dts: DRA7: wdt: Fix compatible property for watchdog node
Date: Tue, 13 Jan 2015 23:23:10 -0800
Message-Id: <20150114072101.236823451@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lokesh Vutla <lokeshvutla@ti.com>

commit be6688350a4470e417aaeca54d162652aab40ac5 upstream.

OMAP wdt driver supports only ti,omap3-wdt compatible. In DRA7 dt
wdt compatible property is defined as ti,omap4-wdt by mistake instead of
ti,omap3-wdt. Correcting the typo.

Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -653,7 +653,7 @@
 		};
 
 		wdt2: wdt@4ae14000 {
-			compatible = "ti,omap4-wdt";
+			compatible = "ti,omap3-wdt";
 			reg = <0x4ae14000 0x80>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "wd_timer2";


