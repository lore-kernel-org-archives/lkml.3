Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3JNPVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:21:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57593 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3JNPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:21:43 -0400
Message-ID: <525C0C02.7030404@gmail.com>
Date: Mon, 14 Oct 2013 20:51:38 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: wsa@the-dreams.de
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi23ganiga@gmail.com
Subject: [PATCH 1/3] i2c: i2c-core: fix paranthesis coding style issue in,
 i2c-core.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 46aed97f5e5a434e8ec24c14e085a138958ba559 Mon Sep 17 00:00:00 2001
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Date: Sun, 13 Oct 2013 19:13:46 +0530
Subject: [PATCH 1/3] i2c: i2c-core: fix paranthesis coding style issue in
 i2c-core.c

This is a patch to the i2c-core.c file that fixes the paranthesis
warning found by the checkpatch.pl tool

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/i2c/i2c-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..b1197bb 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -637,7 +637,7 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	struct i2c_client	*client;
 	int			status;
 
-	client = kzalloc(sizeof *client, GFP_KERNEL);
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return NULL;
 
-- 
1.7.10.4
