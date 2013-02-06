Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3BFLDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:03:32 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:54951 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab3BFKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/49] regulator: ab8500: Correct TVOUT regulator start-up delay
Date: Wed,  6 Feb 2013 10:53:46 +0000
Message-Id: <1360148051-7560-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Update TVOUT regulator to match specification. (Was 10ms,
changed to 500us.)

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 104a4c7..df4fd1a 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -484,9 +484,9 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2000000,
-			.enable_time	= 10000,
+			.enable_time	= 500,
 		},
-		.delay			= 10000,
+		.delay			= 500,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.9.5

