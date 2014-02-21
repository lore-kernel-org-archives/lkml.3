Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaBUBLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:11:50 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34864 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaBUBLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:11:48 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: JBottomley@parallels.com
Cc: jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] be2iscsi: make beiscsi_process_mcc() as static
Date: Fri, 21 Feb 2014 10:11:40 +0900
Message-ID: <4848622.esnnEkYuHI@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 137a2f619f1fa93fc497d891954d83c6cb307d11 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 21 Feb 2014 08:43:56 +0900
Subject: [PATCH] [SCSI] be2iscsi: make beiscsi_process_mcc() as static

beiscsi_process_mcc() is only referenced in this file.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1ec9793..d4fff8a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -398,7 +398,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 }
 
 
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+static int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num = 0, status = 0;
-- 
1.7.9.5


