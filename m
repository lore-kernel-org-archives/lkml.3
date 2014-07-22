Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaGVLNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:13:45 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34383 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaGVLMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:12:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/19] mfd: wm8350-i2c: Replace spaces with tabs
Date: Tue, 22 Jul 2014 12:11:19 +0100
Message-Id: <1406027485-15657-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: please, no spaces at the start of a line
+       { "wm8350", 0 },$

WARNING: please, no spaces at the start of a line
+       { "wm8351", 0 },$

WARNING: please, no spaces at the start of a line
+       { "wm8352", 0 },$

WARNING: please, no spaces at the start of a line
+       { }$

total: 0 errors, 4 warnings, 93 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8350-i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index f919def..6a16a8a 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -58,10 +58,10 @@ static int wm8350_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id wm8350_i2c_id[] = {
-       { "wm8350", 0 },
-       { "wm8351", 0 },
-       { "wm8352", 0 },
-       { }
+	{ "wm8350", 0 },
+	{ "wm8351", 0 },
+	{ "wm8352", 0 },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm8350_i2c_id);
 
-- 
1.8.3.2

