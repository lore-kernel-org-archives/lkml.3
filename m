Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaDYRub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:50:31 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39442 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaDYRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:50:28 -0400
Message-ID: <535AA05D.5080304@gmail.com>
Date: Fri, 25 Apr 2014 23:20:21 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: ravi23ganiga@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7bdc654b12895889a539450528b52328901e6dc0 Mon Sep 17 00:00:00 2001
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Date: Fri, 25 Apr 2014 23:11:22 +0530
Subject: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c

This is a patch to fix coding style
warnings found by the checkpatch.pl tool

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ea6dc36..0cd67d0 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1435,13 +1435,15 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
 	s = &dev->subdevices[cmd->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
+		dev_dbg(dev->class_dev,
+			"%d not valid subdevice\n", cmd->subdev);
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
