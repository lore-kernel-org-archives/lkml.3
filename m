Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3EQLWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:22:40 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53239 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3EQLWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:22:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RESEND] scsi/trivial: Spelling hsot -> host
Date: Fri, 17 May 2013 13:22:29 +0200
Message-Id: <1368789749-4413-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/aic7xxx_old/aic7xxx.seq |    2 +-
 drivers/scsi/scsi_error.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.seq b/drivers/scsi/aic7xxx_old/aic7xxx.seq
index 823ff28..dc3bb81 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.seq
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.seq
@@ -693,7 +693,7 @@ p_status:
  * it's own message.
  * 
  * If MSG_OUT is == HOST_MSG, also interrupt the host and take a message.
- * This is done to allow the hsot to send messages outside of an identify
+ * This is done to allow the host to send messages outside of an identify
  * sequence while protecting the seqencer from testing the MK_MESSAGE bit
  * on an SCB that might not be for the current nexus. (For example, a
  * BDR message in response to a bad reselection would leave us pointed to
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..ade98e2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -538,7 +538,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
-- 
1.7.0.4

