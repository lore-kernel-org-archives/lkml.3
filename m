Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbaGSJz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:55:59 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44899 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760914AbaGSJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:55:55 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/4] Fix misceanellous problems reported by checkpatch
Date: Sat, 19 Jul 2014 11:55:42 +0200
Message-Id: <1405763743-30023-4-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/staging/sep/sep_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 1580d95f..6f98881 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -130,7 +130,6 @@ void sep_queue_status_remove(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "[PID%d] sep_queue_status_remove return\n",
 		current->pid);
-	return;
 }
 
 /**
@@ -1737,7 +1736,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 		return;
 	}
 
-	while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
+	while ((unsigned long)lli_table_ptr->bus_address != 0xffffffff) {
 		dev_dbg(&sep->pdev->dev,
 			"[PID%d] lli table %08lx, table_data_size is (hex) %lx\n",
 			current->pid, table_count, table_data_size);
@@ -1752,7 +1751,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 			dev_dbg(&sep->pdev->dev,
 				"[PID%d] lli_table_ptr address is %08lx\n",
 				current->pid,
-				(unsigned long) lli_table_ptr);
+				(unsigned long)lli_table_ptr);
 
 			dev_dbg(&sep->pdev->dev,
 				"[PID%d] phys address is %08lx block size is (hex) %x\n",
-- 
1.8.5.5

