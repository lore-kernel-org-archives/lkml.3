Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbaD3RfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:35:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63128 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3RfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:35:17 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: ravi23ganiga@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c
Date: Wed, 30 Apr 2014 23:04:49 +0530
Message-Id: <1398879289-20442-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix coding style
warnings found by the checkpatch.pl tool

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index acc8019..a62d639 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1435,13 +1435,15 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
 	s = &dev->subdevices[cmd->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
+		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
+			cmd->subdev);
 		return -EIO;
 	}
 
 	if (!s->do_cmd || !s->do_cmdtest || !s->async) {
 		dev_dbg(dev->class_dev,
-			"subdevice %d does not support commands\n", cmd->subdev);
+			"subdevice %d does not support commands\n",
+			cmd->subdev);
 		return -EIO;
 	}
 
-- 
1.7.10.4

