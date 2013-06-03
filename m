Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3FCNnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:13 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:58867 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3FCNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/21] ARM: ux500: Supply the RTC clock lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:28 +0100
Message-Id: <1370266965-7901-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 6eec1cd..fe7cb84 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -53,6 +53,9 @@
 			compatible = "arm,rtc-pl031", "arm,primecell";
 			reg = <0x80154000 0x1000>;
 			interrupts = <0 18 0x4>;
+
+			clocks = <&clk 3>;
+			clock-names = "apb_pclk";
 		};
 
 		gpio0: gpio@8012e000 {
-- 
1.7.10.4

