Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaDDKFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:05:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40275 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaDDKFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:05:41 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: pcl812.c: fixed a coding style issue
Date: Fri,  4 Apr 2014 13:05:29 +0300
Message-Id: <1396605929-10514-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue. Reported by checkpatch.pl

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 160eac8..5cc01fe 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -811,8 +811,9 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 				devpriv->ai_dma = 0;
 				break;
 			}
-	} else
+	} else {
 		devpriv->ai_dma = 0;
+	}
 
 	devpriv->ai_act_scan = 0;
 	devpriv->ai_poll_ptr = 0;
-- 
1.8.5.3

