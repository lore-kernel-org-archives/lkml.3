Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaHSPGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:06:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58311 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaHSPGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: comedi: ni_labpc: remove unnecessary braces in labpc_common_attach()
Date: Tue, 19 Aug 2014 16:06:28 +0100
Message-Id: <1408460793-29793-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
References: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct checkpatch issue "WARNING: braces {} are not necessary for any
arm of this statement".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index c9c090e..f5e78ad 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1390,11 +1390,10 @@ int labpc_common_attach(struct comedi_device *dev,
 
 	/* 8255 dio */
 	s = &dev->subdevices[2];
-	if (dev->mmio) {
+	if (dev->mmio)
 		ret = subdev_8255_mm_init(dev, s, NULL, DIO_BASE_REG);
-	} else {
+	else
 		ret = subdev_8255_init(dev, s, NULL, DIO_BASE_REG);
-	}
 	if (ret)
 		return ret;
 
-- 
2.0.4

