Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3KWLhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 06:37:10 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46841 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3KWLhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 06:37:07 -0500
From: Abhishek Sudhakaran <itzurabhi@gmail.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Abhishek Sudhakaran <itzurabhi@gmail.com>
Subject: [PATCH] Staging:comedi:pcmmio Fixed a printk format in debug section
Date: Sat, 23 Nov 2013 17:05:32 +0530
Message-Id: <1385206533-3289-1-git-send-email-itzurabhi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a printk statement in the debug section
where the string terminator was misplaced.

Signed-off-by: Abhishek Sudhakaran <itzurabhi@gmail.com>
---
 drivers/staging/comedi/drivers/pcmmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 14cee3a..bc1f44c 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -274,7 +274,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
 		printk
-		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x,"
+		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x",
 		     " data_in %02x ", byte_no, (unsigned)write_mask_byte,
 		     (unsigned)data_byte, offset, ioaddr, (unsigned)byte);
 #endif
-- 
1.7.9.5

