Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbbAFKRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:17:08 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62742 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbAFKRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:17:04 -0500
From: Piotr Kubus <p.t.kubus@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Piotr Kubus <p.t.kubus@gmail.com>
Subject: [PATCH v2] Staging: comedi: dmm32at: Fix a code indent issue
Date: Tue,  6 Jan 2015 11:16:16 +0100
Message-Id: <1420539376-15323-1-git-send-email-p.t.kubus@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a code indent error found by checkpatch.pl in dmm32at.c.

Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
---
v2: make the commit message clearer and shorter

 drivers/staging/comedi/drivers/dmm32at.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 6df298a..31919b8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 	/* enable the ai conversion interrupt and the clock to start scans */
 	outb(DMM32AT_INTCLK_ADINT |
 	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
-             dev->iobase + DMM32AT_INTCLK_REG);
+	     dev->iobase + DMM32AT_INTCLK_REG);
 }
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
-- 
1.9.1

