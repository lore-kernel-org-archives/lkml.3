Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaLEM7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:59:01 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46387 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaLEM7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:59:00 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:watchdog: Fixed missing blank line warning
Date: Fri,  5 Dec 2014 18:29:00 +0530
Message-Id: <1417784340-6013-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
Missing a blank line after declarations

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/watchdog/mixcomwd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index be86ea3..03b7612e 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -183,6 +183,7 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data,
 
 			for (i = 0; i != len; i++) {
 				char c;
+
 				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
-- 
1.7.9.5

