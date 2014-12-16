Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaLPQZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:25:50 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64608 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:25:48 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH 3/8] drivers: watchdog: Fixed missing blank line warning
Date: Tue, 16 Dec 2014 21:55:24 +0530
Message-Id: <1418747129-3766-3-git-send-email-andnlnbn18@gmail.com>
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
 drivers/watchdog/alim1535_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 3a17fbd..a505a78 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -154,6 +154,7 @@ static ssize_t ali_write(struct file *file, const char __user *data,
 			   the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
+
 				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
@@ -218,6 +219,7 @@ static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case WDIOC_SETTIMEOUT:
 	{
 		int new_timeout;
+
 		if (get_user(new_timeout, p))
 			return -EFAULT;
 		if (ali_settimer(new_timeout))
-- 
1.7.9.5

