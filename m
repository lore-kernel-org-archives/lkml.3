Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaLRPe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:34:26 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:59942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaLRPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:34:25 -0500
From: Aapo Vienamo <aapo.vienamo@iki.fi>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aapo.vienamo@iki.fi
Subject: [PATCH] Staging: comedi: fix redundant parens in return in amplc_dio200_common.c
Date: Thu, 18 Dec 2014 17:32:52 +0200
Message-Id: <1418916772-24778-1-git-send-email-aapo.vienamo@iki.fi>
X-Mailer: git-send-email 2.0.4
X-SA-Exim-Connect-IP: 88.112.32.252
X-SA-Exim-Mail-From: aapo.vienamo@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a coding style issue found by the checkpatch.pl tool in
amplc_dio200_common.c by removing the unnecessary parentheses around the
expression in a return statement.

Signed-off-by: Aapo Vienamo <aapo.vienamo@iki.fi>
---
 drivers/staging/comedi/drivers/amplc_dio200_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
index 26aad70..6eadbbe 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
@@ -340,7 +340,7 @@ static int dio200_handle_read_intr(struct comedi_device *dev,
 
 	comedi_handle_events(dev, s);
 
-	return (triggered != 0);
+	return triggered != 0;
 }
 
 static int dio200_subdev_intr_cancel(struct comedi_device *dev,
-- 
2.0.4

