Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaLPQ0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:26:03 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43945 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLPQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:26:00 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH 5/8] drivers: watchdog: Fixed missing blank line warning
Date: Tue, 16 Dec 2014 21:55:26 +0530
Message-Id: <1418747129-3766-5-git-send-email-andnlnbn18@gmail.com>
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
 drivers/watchdog/acquirewdt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 5614416..d78a120 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -132,6 +132,7 @@ static ssize_t acq_write(struct file *file, const char __user *buf,
 			   magic character */
 			for (i = 0; i != count; i++) {
 				char c;
+
 				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
-- 
1.7.9.5

