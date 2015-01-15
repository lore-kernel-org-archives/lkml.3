Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbbAOPdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:33:20 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43731 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbbAOPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:33:14 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH v2 6/8] watchdog: ar7_wdt: Fixed missing blank line warning
Date: Thu, 15 Jan 2015 21:02:04 +0530
Message-Id: <1421335926-3321-6-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421335926-3321-1-git-send-email-andnlnbn18@gmail.com>
References: <1421335926-3321-1-git-send-email-andnlnbn18@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a blank line after declarations to remove the checkpatch warning:
'Missing blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
Changes in v2:
  - Make the commit message more clearer.

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

