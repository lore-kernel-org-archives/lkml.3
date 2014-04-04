Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaDDU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:57:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53230 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaDDU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:57:34 -0400
From: Camille Begue <camille.begue44@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Camille Begue <camille.begue44@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/1] staging: comedi: Fix checkpatch warning
Date: Fri,  4 Apr 2014 22:57:18 +0200
Message-Id: <1396645041-15567-1-git-send-email-camille.begue44@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap lines > 80 columns.
This patch is part of eudyptula challenge

Signed-off-by: Camille Begue <camille.begue44@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ea6dc36..252505b 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1435,13 +1435,14 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
 	s = &dev->subdevices[cmd->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
+		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
+			cmd->subdev);
 		return -EIO;
 	}
 
 	if (!s->do_cmd || !s->do_cmdtest || !s->async) {
-		dev_dbg(dev->class_dev,
-			"subdevice %d does not support commands\n", cmd->subdev);
+		dev_dbg(dev->class_dev, "subdevice %d does not support commands\n",
+			cmd->subdev);
 		return -EIO;
 	}
 
-- 
1.9.1

