Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaLRFTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:19:07 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62525 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaLRFTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:19:06 -0500
From: Frederic Jacob <frederic.jacob.78@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Frederic Jacob <frederic.jacob.78@gmail.com>
Subject: [PATCHv2] Staging: comedi: fix blank line coding style in comedi_bond.c
Date: Thu, 18 Dec 2014 00:15:07 -0500
Message-Id: <1418879707-3690-1-git-send-email-frederic.jacob.78@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141218025716.GA9737@kroah.com>
References: <20141218025716.GA9737@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a patch to the comedi_bond.c file that fixes up a blank line after
 declaration warning found by the checkpatch.pl tool 

Signed-off-by: Frederic Jacob <frederic.jacob.78@gmail.com>
---
v2: Fix description line-wrap and add a line before Signed-off-by
 drivers/staging/comedi/drivers/comedi_bond.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 85b2f4a..221d381 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -261,6 +261,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			{
 				/* Append dev:subdev to devpriv->name */
 				char buf[20];
+
 				snprintf(buf, sizeof(buf), "%u:%u ",
 					 bdev->minor, bdev->subdev);
 				strlcat(devpriv->name, buf,
-- 
1.9.1

