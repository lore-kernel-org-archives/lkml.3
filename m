Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbbAZN0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:26:04 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:36275 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbbAZNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:25:43 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] staging: comedi: 8255.c: reformat remaining block comments
Date: Mon, 26 Jan 2015 13:25:24 +0000
Message-Id: <1422278725-17740-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
References: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment formatting style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8255.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 1476157..c2f15de 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -264,10 +264,9 @@ int subdev_8255_mm_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	return __subdev_8255_init(dev, s, io, regbase, true);
 }
 EXPORT_SYMBOL_GPL(subdev_8255_mm_init);
-/*
-
-   Start of the 8255 standalone device
 
+/*
+ * Start of the 8255 standalone device
  */
 
 static int dev_8255_attach(struct comedi_device *dev,
-- 
2.1.4

