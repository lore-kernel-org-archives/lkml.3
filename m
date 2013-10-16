Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510Ab3JPTZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:25:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38903 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JPTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:25:10 -0400
From: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dhanunjaya <dhanunjaya.matrix@gmail.com>
Subject: [PATCH 1/4] Staging: comedi: fix semicolon coding style issue in ni_660x.c
Date: Thu, 17 Oct 2013 00:54:52 +0530
Message-Id: <1381951492-20654-1-git-send-email-dhanunjaya.matrix@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhanunjaya <dhanunjaya.matrix@gmail.com>

This is a patch to the ni_660x.c file that fixes up a semicolon warning
found by the checkpatch.pl tool.

Signed-off-by: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
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

