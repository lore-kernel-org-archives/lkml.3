Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaDQEFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 00:05:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61718 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaDQEFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 00:05:22 -0400
From: Thomas Tanaka <thomas.tanaka@gmail.com>
To: gregkh@linuxfoundation.org
Cc: monamagarwal123@gmail.com, thomas.tanaka@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rts5139: fixed coding style
Date: Wed, 16 Apr 2014 21:05:09 -0700
Message-Id: <1397707509-22215-1-git-send-email-thomas.tanaka@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warnings > 80 lines

Signed-off-by: Thomas Tanaka <thomas.tanaka@gmail.com>
---
 drivers/staging/rts5139/rts51x_fop.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_fop.c b/drivers/staging/rts5139/rts51x_fop.c
index 677d18b..cf4e675 100644
--- a/drivers/staging/rts5139/rts51x_fop.c
+++ b/drivers/staging/rts5139/rts51x_fop.c
@@ -70,7 +70,8 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 	switch (dir) {
 	case 0:
 		/* No data */
-		retval = ext_rts51x_sd_execute_no_data(chip, chip->card2lun[SD_CARD],
+		retval = ext_rts51x_sd_execute_no_data(chip,
+						chip->card2lun[SD_CARD],
 						cmd_idx, standby, acmd,
 						rsp_code, arg);
 		if (retval != TRANSPORT_GOOD)
@@ -83,10 +84,11 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 		if (!buf)
 			TRACE_RET(chip, STATUS_NOMEM);
 
-		retval = ext_rts51x_sd_execute_read_data(chip, chip->card2lun[SD_CARD],
-						  cmd_idx, cmd12, standby, acmd,
-						  rsp_code, arg, len, buf,
-						  cmnd->buf_len, 0);
+		retval = ext_rts51x_sd_execute_read_data(chip,
+						chip->card2lun[SD_CARD],
+						cmd_idx, cmd12, standby, acmd,
+						rsp_code, arg, len, buf,
+						cmnd->buf_len, 0);
 		if (retval != TRANSPORT_GOOD) {
 			kfree(buf);
 			TRACE_RET(chip, STATUS_FAIL);
@@ -117,10 +119,11 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 		}
 
 		retval =
-		    ext_rts51x_sd_execute_write_data(chip, chip->card2lun[SD_CARD],
-					      cmd_idx, cmd12, standby, acmd,
-					      rsp_code, arg, len, buf,
-					      cmnd->buf_len, 0);
+		    ext_rts51x_sd_execute_write_data(chip,
+						chip->card2lun[SD_CARD],
+						cmd_idx, cmd12, standby, acmd,
+						rsp_code, arg, len, buf,
+						cmnd->buf_len, 0);
 		if (retval != TRANSPORT_GOOD) {
 			kfree(buf);
 			TRACE_RET(chip, STATUS_FAIL);
-- 
1.7.9.5

