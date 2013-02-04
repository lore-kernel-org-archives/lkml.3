Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3BDL5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:48 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49080 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BDL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:45 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 59/73] regulator: ab8500: Change mode fix for LDO USB
Date: Mon,  4 Feb 2013 11:54:14 +0000
Message-Id: <1359978868-28736-60-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch corrects a bug which makes it impossible to change
mode on regulator LDO USB.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index cfa01b1..8da7ac9 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -966,7 +966,7 @@ static struct ab8500_regulator_info
 	[AB8505_LDO_USB] = {
 		.desc = {
 			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_ops,
+			.ops            = &ab8500_regulator_mode_ops,
 			.type           = REGULATOR_VOLTAGE,
 			.id             = AB8505_LDO_USB,
 			.owner          = THIS_MODULE,
-- 
1.7.9.5

