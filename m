Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3BDMIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:08:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39980 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3BDL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Philippe Langlais <philippe.langlais@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 36/73] ARM: ux500: Partially revert changes surrounding audio regulators
Date: Mon,  4 Feb 2013 11:53:51 +0000
Message-Id: <1359978868-28736-37-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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

