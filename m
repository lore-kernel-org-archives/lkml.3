Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab3FFMOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:14:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62398 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FFMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:13:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/32] ARM: ux500: Add PRCC Peripheral clock node to DBx500 Device Tree
Date: Thu,  6 Jun 2013 13:13:19 +0100
Message-Id: <1370520828-31165-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370520828-31165-1-git-send-email-lee.jones@linaro.org>
References: <1370520828-31165-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index c5f187b..18c5c27 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -49,6 +49,10 @@
 			prcmu_clk: prcmu-clock {
 				#clock-cells = <1>;
 			};
+
+			prcc_pclk: prcc-periph-clock {
+				#clock-cells = <2>;
+			};
 		};
 
 		timer@a0410600 {
-- 
1.7.10.4

