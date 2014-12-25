Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaLYU2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:28:39 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41238 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaLYU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:28:38 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Jeremiah Mahler <jmmahler@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Decotigny <ddecotig@gmail.com>
Subject: [PATCH v2] staging: comedi: dmm32at: fix style issues
Date: Thu, 25 Dec 2014 12:28:28 -0800
Message-Id: <1419539308-19059-1-git-send-email-ddecotig@gmail.com>
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
2.2.0.rc0.207.ga3a616c

