Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaABRZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:25:31 -0500
Received: from [198.211.127.236] ([198.211.127.236]:37125 "EHLO
	mail.josephb.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbaABRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:25:27 -0500
From: Joe Borg <cyborg101010@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cyborg101010@gmail.com
Subject: [PATCH] DAS6042: Fixing typeo.
Date: Thu,  2 Jan 2014 17:25:20 +0000
Message-Id: <1388683520-25555-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing foo * bar should be foo *bar.

Fixed by Joe Borg root@josephb.org
---
 drivers/staging/comedi/drivers/das6402.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index fb25cb8..37ae356 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -211,7 +211,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 
 #ifdef unused
 static int das6402_ai_mode2(struct comedi_device *dev,
-			    struct comedi_subdevice *s, comedi_trig * it)
+			    struct comedi_subdevice *s, comedi_trig *it)
 {
 	struct das6402_private *devpriv = dev->private;
 
-- 
1.8.5.2

