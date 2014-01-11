Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaAKOtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 09:49:20 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51049 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaAKOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 09:48:52 -0500
From: Joe Borg <cyborg101010@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cyborg101010@gmail.com
Subject: [PATCH] DAS6402: Fixing foo * bar should be foo *bar
Date: Sat, 11 Jan 2014 14:48:48 +0000
Message-Id: <1389451728-3575-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2.309.ga25014b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.5.2.309.ga25014b

