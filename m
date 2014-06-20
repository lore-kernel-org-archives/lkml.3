Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074AbaFTIkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:40:37 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46567 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748AbaFTIke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:40:34 -0400
From: pramod.gurav.etc@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>
Subject: [PATCH] staging: alarm-dev: Set the license to GPL
Date: Fri, 20 Jun 2014 14:13:59 +0530
Message-Id: <1403253839-30923-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav.etc@gmail.com>

Adding "GPL" license to fix a warning while compiling as
module.

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Brian Swetland <swetland@google.com>
Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 2fc7cdd..309aafe 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -442,4 +442,4 @@ static void  __exit alarm_dev_exit(void)
 
 module_init(alarm_dev_init);
 module_exit(alarm_dev_exit);
-
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

