Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbbAEOuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:50:51 -0500
Received: from smtp-out12.tpgi.com.au ([220.244.226.122]:33636 "EHLO
	mail12.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388AbbAEOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:50:50 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 09:50:49 EST
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Tue, 6 Jan 2015 01:31:57 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: gregkh@linuxfoundation.org, fabio.falzoi84@gmail.com,
        roxanagabriela10@gmail.com, yejiayily@gmail.com, julia.lawall@lip6.fr,
        himangi774@gmail.com, tapaswenipathak@gmail.com, emrys@paradise.net.nz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rts5208: fix space prohibited before ',' error in ms.c
Date: Tue,  6 Jan 2015 01:29:01 +1100
Message-Id: <1420468141-29657-1-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch.pl errors:
ERROR: space prohibited before that ',' (ctx:WxW)

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/rts5208/ms.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index b4612fb..7454634 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -781,7 +781,7 @@ static int msxc_change_power(struct rtsx_chip *chip, u8 mode)
 	buf[4] = 0;
 	buf[5] = 0;
 
-	retval = ms_write_bytes(chip, PRO_WRITE_REG , 6, NO_WAIT_INT, buf, 6);
+	retval = ms_write_bytes(chip, PRO_WRITE_REG, 6, NO_WAIT_INT, buf, 6);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
@@ -1291,7 +1291,7 @@ static int ms_write_extra_data(struct rtsx_chip *chip,
 	for (i = 6; i < MS_EXTRA_SIZE + 6; i++)
 		data[i] = buf[i - 6];
 
-	retval = ms_write_bytes(chip, WRITE_REG , (6+MS_EXTRA_SIZE),
+	retval = ms_write_bytes(chip, WRITE_REG, (6+MS_EXTRA_SIZE),
 				NO_WAIT_INT, data, 16);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1342,7 +1342,7 @@ static int ms_read_page(struct rtsx_chip *chip, u16 block_addr, u8 page_num)
 	data[4] = 0x20;
 	data[5] = page_num;
 
-	retval = ms_write_bytes(chip, WRITE_REG , 6, NO_WAIT_INT, data, 6);
+	retval = ms_write_bytes(chip, WRITE_REG, 6, NO_WAIT_INT, data, 6);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
@@ -1619,7 +1619,7 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 		data[4] = 0x20;
 		data[5] = i;
 
-		retval = ms_write_bytes(chip, WRITE_REG , 6, NO_WAIT_INT,
+		retval = ms_write_bytes(chip, WRITE_REG, 6, NO_WAIT_INT,
 					data, 6);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
@@ -1988,7 +1988,7 @@ RE_SEARCH:
 		RTSX_WRITE_REG(chip, PPBUF_BASE2, 0xFF, 0x88);
 		RTSX_WRITE_REG(chip, PPBUF_BASE2 + 1, 0xFF, 0);
 
-		retval = ms_transfer_tpc(chip, MS_TM_WRITE_BYTES, WRITE_REG , 1,
+		retval = ms_transfer_tpc(chip, MS_TM_WRITE_BYTES, WRITE_REG, 1,
 					NO_WAIT_INT);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-- 
2.2.1

