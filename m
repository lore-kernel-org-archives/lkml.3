Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbaGXP1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:27:11 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55884 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbaGXP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:27:08 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH 3/3] staging: dgnc: Fix space required after that ','
Date: Fri, 25 Jul 2014 00:26:53 +0900
Message-Id: <1406215613-9314-3-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
References: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch errors:
"space required after that ','"

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index f7730a1..b68246a 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -219,8 +219,8 @@
  * Makes spotting lock/unlock locations easier.
  */
 # define DGNC_SPINLOCK_INIT(x)		spin_lock_init(&(x))
-# define DGNC_LOCK(x,y)			spin_lock_irqsave(&(x), y)
-# define DGNC_UNLOCK(x,y)		spin_unlock_irqrestore(&(x), y)
+# define DGNC_LOCK(x, y)		spin_lock_irqsave(&(x), y)
+# define DGNC_UNLOCK(x, y)		spin_unlock_irqrestore(&(x), y)
 
 /*
  * All the possible states the driver can be while being loaded.
-- 
1.7.9.5

