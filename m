Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926Ab3CUQAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:00:41 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:44398 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab3CUQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/46] ARM: ux500: regulators: List the MMIO camera as a consumer of VAUX1
Date: Thu, 21 Mar 2013 15:59:14 +0000
Message-Id: <1363881583-15234-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MMIO camera uses the VAUX1 as it's voltage supply.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 3d63c8d..b08c8c8 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -81,6 +81,8 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vdd", "2-005c"),
 	/* Cypress TrueTouch Touchscreen device */
 	REGULATOR_SUPPLY("vcpin", "spi8.0"),
+	/* Camera device */
+	REGULATOR_SUPPLY("vaux12v5", "mmio_camera"),
 };
 
 static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
-- 
1.7.10.4

