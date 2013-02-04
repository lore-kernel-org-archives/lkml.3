Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3BDMKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:10:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44581 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3BDL4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/73] ARM: ux500: Add supply for the Cypress TrueTouch Touchscreen
Date: Mon,  4 Feb 2013 11:53:43 +0000
Message-Id: <1359978868-28736-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lists the Cypress TrueTouch Touchscreen as a consumer
of the AB8500 VAUX1 regulator.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index baf6f01..c4c740f 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -81,6 +81,8 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vdd", "3-0029"),
 	/* Pressure sensor device */
 	REGULATOR_SUPPLY("vdd", "2-005c"),
+	/* Cypress TrueTouch Touchscreen device */
+	REGULATOR_SUPPLY("vcpin", "spi8.0"),
 };
 
 static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
-- 
1.7.9.5

