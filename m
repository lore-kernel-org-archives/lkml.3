Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3BFLCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:02:30 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:59778 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3BFKzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/49] ARM: ux500: Partially revert changes surrounding audio regulators
Date: Wed,  6 Feb 2013 10:53:48 +0000
Message-Id: <1360148051-7560-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 4bd982f..16745e2 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -108,22 +108,22 @@ static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 
 static struct regulator_consumer_supply ab8500_vaud_consumers[] = {
 	/* AB8500 audio-codec main supply */
-	REGULATOR_SUPPLY("vaud", "ab8500-codec.0"),
+	REGULATOR_SUPPLY("v-audio", NULL),
 };
 
 static struct regulator_consumer_supply ab8500_vamic1_consumers[] = {
 	/* AB8500 audio-codec Mic1 supply */
-	REGULATOR_SUPPLY("vamic1", "ab8500-codec.0"),
+	REGULATOR_SUPPLY("v-amic1", NULL),
 };
 
 static struct regulator_consumer_supply ab8500_vamic2_consumers[] = {
 	/* AB8500 audio-codec Mic2 supply */
-	REGULATOR_SUPPLY("vamic2", "ab8500-codec.0"),
+	REGULATOR_SUPPLY("v-amic2", NULL),
 };
 
 static struct regulator_consumer_supply ab8500_vdmic_consumers[] = {
 	/* AB8500 audio-codec DMic supply */
-	REGULATOR_SUPPLY("vdmic", "ab8500-codec.0"),
+	REGULATOR_SUPPLY("v-dmic", NULL),
 };
 
 static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
-- 
1.7.9.5

