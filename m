Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaGQJCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:02:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38698 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbaGQJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:02:00 -0400
From: sanjeev sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <daniel@ffwll.ch>, <waydi1@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <swetland@google.com>,
        sanjeevs1 <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2] staging: android: Fixed missing blank line
Date: Thu, 17 Jul 2014 14:43:27 +0530
Message-ID: <1405588407-9051-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 17 Jul 2014 09:01:57.0922 (UTC) FILETIME=[C384A020:01CFA19D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeevs1 <sanjeev_sharma@mentor.com>

This patch will add an blank line after
declaration reported by checkpatch.pl script.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
Changes in v2:
  - Fixed frm header

 drivers/staging/android/sw_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3f..863d4b1 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
 				       char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
 	snprintf(str, size, "%d", pt->value);
 }
 
@@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
 static int sw_sync_release(struct inode *inode, struct file *file)
 {
 	struct sw_sync_timeline *obj = file->private_data;
+
 	sync_timeline_destroy(&obj->obj);
 	return 0;
 }
-- 
1.7.11.7

