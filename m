Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaGVOwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:52:55 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58396 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaGVOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:52:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, dbaryshkov@gmail.com
Subject: [PATCH 3/5] ARM: sti: Add Restart support for the STiH417 (Cannes) board
Date: Tue, 22 Jul 2014 15:52:30 +0100
Message-Id: <1406040752-25229-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..a370e73 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -63,6 +63,12 @@
 		ranges;
 		compatible = "simple-bus";
 
+		restart {
+			compatible = "st,stih407-restart";
+			st,syscfg = <&syscfg_sbc_reg>;
+			status = "okay";
+		};
+
 		syscfg_sbc: sbc-syscfg@9620000 {
 			compatible = "st,stih407-sbc-syscfg", "syscon";
 			reg = <0x9620000 0x1000>;
-- 
1.8.3.2

