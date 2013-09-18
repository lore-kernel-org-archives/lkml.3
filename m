Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3IRMYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:24:25 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61701 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3IRMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:14:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/41] ARM: ux500: Supply the USB clock lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:05 +0100
Message-Id: <1379506478-16625-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 089b446..2c1051d 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -241,6 +241,8 @@
 				    "iep_6_14", "oep_6_14",
 				    "iep_7_15", "oep_7_15",
 				    "iep_8",    "oep_8";
+
+			clocks = <&prcc_pclk 5 0>;
 		};
 
 		dma: dma-controller@801C0000 {
-- 
1.8.1.2

