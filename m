Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaC2Sn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:43:58 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54184 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaC2Sn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:43:56 -0400
Date: Sun, 30 Mar 2014 00:14:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 48/55] scsi: Mark function as static in scsi_debug.c
Message-ID: <bb4a36afee7dd2ac6d2cc58e557876f198cadae1.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in scsi_debug.c because it is not used outside
this file.

This eliminates the following warning in scsi_debug.c:
drivers/scsi/scsi_debug.c:1910:6: warning: no previous prototype for ‘dump_sector’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2decc64..356b548 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1907,7 +1907,7 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 	return 0;
 }
 
-void dump_sector(unsigned char *buf, int len)
+static void dump_sector(unsigned char *buf, int len)
 {
 	int i, j;
 
-- 
1.7.9.5

