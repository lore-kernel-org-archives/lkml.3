Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaLRCh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:37:28 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52171 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLRCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:37:27 -0500
From: Frederic Jacob <frederic.jacob.78@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Frederic Jacob <frederic.jacob.78@gmail.com>
Subject: [PATCH] Staging: comedi: fix blank line coding style in comedi_bond.c
Date: Wed, 17 Dec 2014 21:35:41 -0500
Message-Id: <1418870141-10323-1-git-send-email-frederic.jacob.78@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the comedi_bond.c file that fixes up a blank line after declaration warning found by the checkpatch.pl tool
Signed-off-by: Frederic Jacob <frederic.jacob.78@gmail.com>
---
This is my first patch that I send. It is for the Eudyptula chalange task 10.
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

