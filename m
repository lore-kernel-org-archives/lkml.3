Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab3JPMiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:38:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45203 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934095Ab3JPMiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:38:23 -0400
From: Dhanunjaya <dhanunjaya.matrix@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dhanunjaya <dhanunjaya.matrix@gmail.com>
Subject: [PATCH] Staging: comedi: fix semicolon coding style issue in ni_660x.c
Date: Wed, 16 Oct 2013 18:08:14 +0530
Message-Id: <1381927094-13457-1-git-send-email-dhanunjaya.matrix@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_660x.c file that fixes up a semicolon warning
found by the checkpatch.pl tool
---
 drivers/staging/comedi/drivers/ni_660x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 3607336..95bb432 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -28,7 +28,7 @@
  *
  * Encoders work.  PulseGeneration (both single pulse and pulse train)
  * works.  Buffered commands work for input but not output.
- * 
+ *
  * References:
  * DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
  * DAQ 6601/6602 User Manual (NI 322137B-01)
@@ -1232,7 +1232,7 @@ static int ni_660x_auto_attach(struct comedi_device *dev,
 			s->type = COMEDI_SUBD_COUNTER;
 			s->subdev_flags =
 			    SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL |
-			    SDF_CMD_READ /* | SDF_CMD_WRITE */ ;
+			    SDF_CMD_READ; /* | SDF_CMD_WRITE */
 			s->n_chan = 3;
 			s->maxdata = 0xffffffff;
 			s->insn_read = ni_660x_GPCT_rinsn;
-- 
1.8.1.2

