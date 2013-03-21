Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab3CUQAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:00:37 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55905 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3CUQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/46] ARM: ux500: Add supply for the Pressure sensor
Date: Thu, 21 Mar 2013 15:59:12 +0000
Message-Id: <1363881583-15234-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lists the Pressure sensor as a consumer of the AB8500
VAUX1 regulator.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index b3d4747..ce2ae47 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -77,6 +77,8 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vdd", "2-0068"),
 	/* Ambient light sensor device */
 	REGULATOR_SUPPLY("vdd", "3-0029"),
+	/* Pressure sensor device */
+	REGULATOR_SUPPLY("vdd", "2-005c"),
 };
 
 static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
-- 
1.7.10.4

