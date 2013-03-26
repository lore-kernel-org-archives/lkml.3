Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab3CZH30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:29:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3CZH3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:29:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,350,1363104000"; 
   d="scan'208";a="6946242"
From: Ren Mingxin <renmx@cn.fujitsu.com>
To: james.smart@emulex.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH] scsi/lpfc: add return code FAST_IO_FAIL in lpfc_abort_handler() comments
Date: Tue, 26 Mar 2013 15:31:00 +0800
Message-Id: <1364283060-30425-1-git-send-email-renmx@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/26 15:28:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/26 15:28:37,
	Serialize complete at 2013/03/26 15:28:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 98af07c..cc6fc83 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4426,6 +4426,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
  * Return code :
  *   0x2003 - Error
  *   0x2002 - Success
+ *   0x2009 - fast_io_fail_tmo fired
  **/
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
-- 
1.7.1

