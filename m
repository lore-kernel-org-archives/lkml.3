Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaDDPpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:45:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36851 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaDDPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:45:03 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, dan.carpenter@oracle.com, wharms@bfs.de,
        joe@perches.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: comedi: drivers: pcl812.c: add curly braces for checkpatch
Date: Fri,  4 Apr 2014 18:44:44 +0300
Message-Id: <1396626284-15457-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel style is that if one side of the if else statement gets has curly
braces then both side should have them.

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
1.9.0

