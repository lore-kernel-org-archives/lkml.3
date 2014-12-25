Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaLYB5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 20:57:24 -0500
Received: from mail-pa0-f68.google.com ([209.85.220.68]:54880 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaLYB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 20:57:15 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Decotigny <ddecotig@gmail.com>
Subject: [PATCH v1] staging: comedi: dmm32at: fix style issues
Date: Wed, 24 Dec 2014 17:55:38 -0800
Message-Id: <1419472538-8035-1-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
      1 ERROR: code indent should use tabs where possible
      1 WARNING: please, no spaces at the start of a line

After:
  (none)

Signed-off-by: David Decotigny <ddecotig@gmail.com>
---
 drivers/staging/comedi/drivers/dmm32at.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 6df298a..1615103 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -363,9 +363,9 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 	outb(hi2, dev->iobase + DMM32AT_CLK2);
 
 	/* enable the ai conversion interrupt and the clock to start scans */
-	outb(DMM32AT_INTCLK_ADINT |
-	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
-             dev->iobase + DMM32AT_INTCLK_REG);
+	outb(DMM32AT_INTCLK_ADINT | DMM32AT_INTCLK_CLKEN |
+		 DMM32AT_INTCLK_CLKSEL,
+	     dev->iobase + DMM32AT_INTCLK_REG);
 }
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
-- 
2.2.0.rc0.207.ga3a616c

