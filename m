Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaCaUzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:55:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41503 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaCaUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:55:44 -0400
Message-ID: <5339D64B.6000803@gmail.com>
Date: Mon, 31 Mar 2014 22:55:39 +0200
From: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging: comedi: comedy_fops.c: fix line over 80, characters
 warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ea6dc36..2071b7c 100644
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
1.8.3.2


