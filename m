Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3E3N22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:28:28 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:38115 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3E3N2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:11 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/5] ARM: ux500: Fix trivial typo in v-anamic1 comment
Date: Thu, 30 May 2013 15:27:41 +0200
Message-Id: <1369920465-13905-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix VAMIC1 LDO comment in DT files to be make it coherent with the
others.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index b6bc4ff..e6ea7ba 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -460,7 +460,7 @@
 						regulator-compatible = "ab8500_ldo_audio";
 					};
 
-					// supply for v-anamic1 VAMic1-LDO
+					// supply for v-anamic1 VAMIC1 LDO
 					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
 						regulator-compatible = "ab8500_ldo_anamic1";
 					};
-- 
1.8.2

