Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaESQLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:11:54 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61183 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaESQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:11:53 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: [PATCH] Staging: comedi: fixed warning shown by checkpatch tool on cb_das16_cs.c file
Date: Mon, 19 May 2014 21:41:36 +0530
Message-Id: <1400515896-9550-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix the warnings shown by checkpatch tool on
file cb_das16_cs.c

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 645fcb0..eb1b92d 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -184,6 +184,7 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 
 		for (bit = 15; bit >= 0; bit--) {
 			int b = (d >> bit) & 0x1;
+
 			b <<= 1;
 			outw(status1 | b | 0x0000, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
-- 
1.8.3.2

