Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3AYSyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:54:22 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:55998 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3AYSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:54:19 -0500
Date: Fri, 25 Jan 2013 13:54:08 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, wfp5p@virginia.edu,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jake.champlin.27@gmail.com
Subject: [PATCH] Staging: Comedi: amplc_dio200: Fixed Bracing Issue
Message-ID: <20130125185404.GA7672@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Bracing Issue flagged by checkpatch.pl

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_dio200.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 5f309ba..b09269d 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1977,8 +1977,7 @@ static int dio200_auto_attach(struct comedi_device *dev,
 		devpriv->io.u.iobase = (unsigned long)base;
 		devpriv->io.regtype = io_regtype;
 	}
-	switch (thisboard->model)
-	{
+	switch (thisboard->model) {
 	case pcie215_model:
 	case pcie236_model:
 	case pcie296_model:
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com

