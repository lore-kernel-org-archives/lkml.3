Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3ASBbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:31:17 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:32790 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3ASBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:31:15 -0500
Date: Fri, 18 Jan 2013 20:23:36 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jake.champlin.27@gmail.com, hsweeten@visionengravers.com,
        wfp5p@virginia.edu
Subject: [PATCH] Staging: Comedi: amplc_dio200: Fixed bracing issue
Message-ID: <20130119012332.GA1256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style error

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
8123742937
<MuttClient>
