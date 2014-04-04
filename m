Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaDDTP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:15:56 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:44577 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaDDTPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:15:54 -0400
From: Camille Begue <camille.begue44@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Camille Begue <camille.begue44@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] staging: comedi: Fix checkpatch warning
Date: Fri,  4 Apr 2014 21:15:39 +0200
Message-Id: <1396638941-16099-1-git-send-email-camille.begue44@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

