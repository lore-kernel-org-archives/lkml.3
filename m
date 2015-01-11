Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbAKUjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:39:37 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45453 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:39:35 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 2/2] Staging: comedi: kcomedilib: Fixed a typo
Date: Sun, 11 Jan 2015 14:39:19 -0600
Message-Id: <1421008759-26947-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in kcomedilib_main.c file.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/comedi/kcomedilib/kcomedilib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 8777f95..973f544 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -95,7 +95,7 @@ static int comedi_do_insn(struct comedi_device *dev,
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
 		dev_err(dev->class_dev,
-			"%d not useable subdevice\n", insn->subdev);
+			"%d not usable subdevice\n", insn->subdev);
 		ret = -EIO;
 		goto error;
 	}
-- 
1.9.1

