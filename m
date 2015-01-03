Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbbACIhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 03:37:52 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57014 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbACIht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 03:37:49 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 5/5] Staging: comedi: fix line over 80 characters warning
Date: Sat,  3 Jan 2015 14:06:27 +0530
Message-Id: <1420274187-6779-6-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
References: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file pcl812.c that fix up warning line
over 80 character which is found by checkpatch tool.

Singed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 5aeb695..f06347f 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1240,7 +1240,7 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			unsigned long dmabuf;
 
-			dmabuf =  __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
+			dmabuf = __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
 			if (!dmabuf)
 				return -ENOMEM;
 
-- 
1.9.1

