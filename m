Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3HLMcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:32:01 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60771 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3HLMbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:31:23 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/4] ARM: AT91: DTS: sam9x5ek: add WM8731 codec
Date: Mon, 12 Aug 2013 14:31:00 +0200
Message-Id: <1376310662-20003-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
References: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8731 codec on sam9x5ek board is on i2c, address 1A

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Acked-by: Mark Brown <broonie@linaro.org>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index d107241..e6fb309 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -59,6 +59,11 @@
 
 			i2c0: i2c@f8010000 {
 				status = "okay";
+
+				wm8731: wm8731@1a {
+					compatible = "wm8731";
+					reg = <0x1a>;
+				};
 			};
 
 			pinctrl@fffff400 {
-- 
1.7.10.4

