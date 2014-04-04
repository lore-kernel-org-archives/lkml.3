Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaDDUzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:55:37 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48483 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaDDUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:55:36 -0400
From: Camille Begue <camille.begue44@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Camille Begue <camille.begue44@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/1] staging: comedi: Fix checkpatch warning
Date: Fri,  4 Apr 2014 22:55:18 +0200
Message-Id: <1396644920-13925-1-git-send-email-camille.begue44@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap lines > 80 columns.
This patch is part of eudyptula challenge

Signed-off-by: Camille Begue <camille.begue44@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ea6dc36..0f05e87 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1435,13 +1435,16 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
 	s = &dev->subdevices[cmd->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
+		dev_dbg(dev->class_dev,
+			"%d not valid subdevice\n",
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
1.9.1

