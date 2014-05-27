Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaE0VSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:18:42 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57708 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaE0VSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:18:40 -0400
From: Marcin Kostrzewa <marckostrzewa@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marcin Kostrzewa <marckostrzewa@gmail.com>
Subject: [PATCH] remove duplicated comment and fix brace placement in drivers/staging/comedi/drivers/addi-data/hwdrv_acpi3501.c
Date: Tue, 27 May 2014 14:17:35 +0000
Message-Id: <1401200257-790-1-git-send-email-marckostrzewa@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Kostrzewa <marckostrzewa@gmail.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 20e89b0..8add8d8 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -104,9 +104,7 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
 			outl(ul_Command1, dev->iobase + APCI3501_TIMER_CTRL_REG);
 		}
 
-		else if (data[1] == 0)	/* Stop The Watchdog */
-		{
-			/* Stop The Watchdog */
+		else if (data[1] == 0) { /* Stop The Watchdog */
 			ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
 			outl(0x0, dev->iobase + APCI3501_TIMER_CTRL_REG);
-- 
1.9.2

