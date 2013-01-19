Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3ASCn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:43:58 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39180 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ASCn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:43:57 -0500
Date: Fri, 18 Jan 2013 21:44:07 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        hsweeten@visionengravers.com, wfp5p@virginia.edu
Subject: [PATCH] Staging: Comedi: daqboard2000: Fixed Coding Style Issue
Message-ID: <20130119024403.GA3712@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Coding Style Warning

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 992e557..d206c7b 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -485,7 +485,7 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-	udelay(10000);		/* Not in the original code, but I like symmetry... */
+	udelay(10000);	/* Not in the original code, but I like symmetry... */
 }
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
8123742937
<MuttClient>
