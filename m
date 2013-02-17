Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3BQKH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 05:07:26 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:56311 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3BQKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 05:07:25 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: thierry.reding@avionic-design.de, morbidrsa@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: twl: Fix typo that broke build
Date: Sun, 17 Feb 2013 11:08:13 +0100
Message-Id: <1361095693-12385-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <20130216202114.GA18727@avionic-0098.mockup.avionic-design.de>
References: <20130216202114.GA18727@avionic-0098.mockup.avionic-design.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a little type that unfortunately broke the build :-(
Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/pwm/pwm-twl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index 9cd2c9a..bf3fda2 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -230,7 +230,7 @@ out:
 
 static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct twm_pwm_chip *twl = to_twl(chip);
+	struct twl_pwm_chip *twl = to_twl(chip);
 	int ret;
 	u8 val;
 
-- 
1.8.1.3

