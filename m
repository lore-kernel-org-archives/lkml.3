Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaLPQ0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:26:11 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58025 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaLPQ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:26:07 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH 6/8] drivers: watchdog: Fixed missing blank line warning
Date: Tue, 16 Dec 2014 21:55:27 +0530
Message-Id: <1418747129-3766-6-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
References: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations to remove the warning:
'Missing blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/watchdog/ar7_wdt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index ae6c287..d001365 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -202,6 +202,7 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
 			char c;
+
 			if (get_user(c, data + i))
 				return -EFAULT;
 			if (c == 'V')
-- 
1.7.9.5

