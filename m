Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaGBP3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:05 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41788 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGBP3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/12] mfd: ab8500-core: Remove pointless else in if statement
Date: Wed,  2 Jul 2014 16:28:33 +0100
Message-Id: <1404314924-23564-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save a line of code (albeit, it's replaced by a blank line, but
still), as the else is superfluous.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index cf2e6a1..857f19a 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -607,8 +607,8 @@ int ab8500_suspend(struct ab8500 *ab8500)
 {
 	if (atomic_read(&ab8500->transfer_ongoing))
 		return -EINVAL;
-	else
-		return 0;
+
+	return 0;
 }
 
 static struct resource ab8500_gpadc_resources[] = {
-- 
1.8.3.2

