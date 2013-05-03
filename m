Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3ECOdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:21 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43697 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3ECOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/63] ARM: ux500: Supply address location names for the DMA40 DMA controller
Date: Fri,  3 May 2013 15:31:47 +0100
Message-Id: <1367591569-32197-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA40 controller uses two sets of base addresses. In order to have
the resources setup by the of_platform framework so they are searchable
by name instead of index, we have to set names for them. The names have
to be the same as the ones used to fetch them back out of the resource
structure.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index aaa63d0..0f462b7 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -186,6 +186,7 @@
 			compatible = "stericsson,db8500-dma40",
 					"stericsson,dma40";
 			reg = <0x801C0000 0x1000 0x40010000 0x800>;
+			reg-names = "base", "lcpa";
 			interrupts = <0 25 0x4>;
 		};
 
-- 
1.7.10.4

