Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaHSPGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:06:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58328 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaHSPGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:51 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: comedi: ni_labpc: Logical continuations should be on the previous line
Date: Tue, 19 Aug 2014 16:06:31 +0100
Message-Id: <1408460793-29793-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
References: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues "CHECK: Logical continuations should be on the
previous line".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 7210a04..f551a3b 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -929,9 +929,9 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 		devpriv->stat2 = devpriv->read_byte(dev, STAT2_REG);
 
 	if ((devpriv->stat1 & (STAT1_GATA0 | STAT1_CNTINT | STAT1_OVERFLOW |
-			       STAT1_OVERRUN | STAT1_DAVAIL)) == 0
-	    && (devpriv->stat2 & STAT2_OUTA1) == 0
-	    && (devpriv->stat2 & STAT2_FIFONHF)) {
+			       STAT1_OVERRUN | STAT1_DAVAIL)) == 0 &&
+	    (devpriv->stat2 & STAT2_OUTA1) == 0 &&
+	    (devpriv->stat2 & STAT2_FIFONHF)) {
 		return IRQ_NONE;
 	}
 
-- 
2.0.4

