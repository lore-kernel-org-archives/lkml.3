Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaH1OCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:02:17 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:52690 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH1OCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:02:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        devicetree@vger.kernel.org
Subject: [PATCH 1/1] i2c: i2c-st: Rename clock reference to something that exists
Date: Thu, 28 Aug 2014 15:02:03 +0100
Message-Id: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLK_S_ICN_REG_0 hasn't existed for a while now.  This was renamed
over a few commits, then finally removed in commit 5aa02b9 (ARM:
STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/i2c/i2c-st.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt
index 437e0db..4c26fda 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-st.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-st.txt
@@ -31,7 +31,7 @@ i2c0: i2c@fed40000 {
 	compatible	= "st,comms-ssc4-i2c";
 	reg		= <0xfed40000 0x110>;
 	interrupts	=  <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
-	clocks		= <&CLK_S_ICN_REG_0>;
+	clocks		= <&clk_s_a0_ls CLK_ICN_REG>;
 	clock-names	= "ssc";
 	clock-frequency = <400000>;
 	pinctrl-names	= "default";
-- 
1.9.1

