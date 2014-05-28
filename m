Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaE1J2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:28:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48755 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaE1J2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:28:30 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linus.walleij@linaro.org, lee.jones@linaro.org, linux@arm.linux.org.uk,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: ux500: Staticize ab8505_regulators
Date: Wed, 28 May 2014 14:56:05 +0530
Message-Id: <1401269165-2996-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401269165-2996-1-git-send-email-sachin.kamat@linaro.org>
References: <1401269165-2996-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ab8505_regulators' is used only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index a4e139aa2441..32d744e91ec2 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -796,7 +796,7 @@ static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
 	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX6,              0x00, 0x00),
 };
 
-struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
+static struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8505_LDO_AUX1] = {
 		.constraints = {
-- 
1.7.9.5

