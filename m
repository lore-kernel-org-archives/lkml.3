Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3CTLXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:23:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35378 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3CTLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:23:15 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] DTS at91sam9x5ek: i2c1 and i2c2 conflict with macb and lcd
Date: Wed, 20 Mar 2013 12:22:54 +0100
Message-Id: <1363778575-4809-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on at91sam9x5ek, macb0 is enabled, so it conflicts with i2c2 (PB4)
same for i2c1, (conflicts with LCD).
Moreover, only i2c0 is used on this board.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 8a7cf1d..1128565 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -61,14 +61,6 @@
 				status = "okay";
 			};
 
-			i2c1: i2c@f8014000 {
-				status = "okay";
-			};
-
-			i2c2: i2c@f8018000 {
-				status = "okay";
-			};
-
 			pinctrl@fffff400 {
 				mmc0 {
 					pinctrl_board_mmc0: mmc0-board {
-- 
1.7.2.5

