Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3KFKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:16:59 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41230 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/13] ARM: ux500: Add ID properties to 'simply' differentiate between MSPs
Date: Wed,  6 Nov 2013 10:16:17 +0000
Message-Id: <1383732985-18928-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 50ff5ab..63861ee 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -920,6 +920,8 @@
 			clocks = <&prcc_kclk 1 3>, <&prcc_pclk 1 3>;
 			clock-names = "msp", "apb_pclk";
 
+			id = <0>;
+
 			status = "disabled";
 		};
 
@@ -935,6 +937,8 @@
 			clocks = <&prcc_kclk 1 4>, <&prcc_pclk 1 4>;
 			clock-names = "msp", "apb_pclk";
 
+			id = <1>;
+
 			status = "disabled";
 		};
 
@@ -953,6 +957,8 @@
 			clocks = <&prcc_kclk 2 3>, <&prcc_pclk 2 5>;
 			clock-names = "msp", "apb_pclk";
 
+			id = <2>;
+
 			status = "disabled";
 		};
 
@@ -968,6 +974,8 @@
 			clocks = <&prcc_kclk 1 10>, <&prcc_pclk 1 11>;
 			clock-names = "msp", "apb_pclk";
 
+			id = <3>;
+
 			status = "disabled";
 		};
 
-- 
1.8.1.2

