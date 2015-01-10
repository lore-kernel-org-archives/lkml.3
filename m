Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbbAJEuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 23:50:40 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41314 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbAJEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 23:50:38 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v7] Staging: comedi: patch to fix line over 80 characters warning
Date: Sat, 10 Jan 2015 10:20:03 +0530
Message-Id: <1420865403-4932-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to pcl812.c that fix line over 80 characters warning
which is found by checkpatch.pl tool. Reduce the extra space around
equal sign that fix warning.

Signed-off-by: Jitendra kumar khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index ac243ca..9b576bc 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1235,7 +1235,7 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			unsigned long dmabuf;
 
-			dmabuf =  __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
+			dmabuf = __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
 			if (!dmabuf)
 				return -ENOMEM;
 
-- 
1.9.1

