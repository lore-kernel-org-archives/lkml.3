Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3KUUBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:15 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64472 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:11 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 2/7] Staging: comedi: fix line over 80 character warning in unioxx5.c
Date: Fri, 22 Nov 2013 01:27:53 +0530
Message-Id: <1385063878-10267-3-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix a line over 80 character warning found by
checkpatch.pl in a comment. The comment was reworded to fix
the warning

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 725595f..2b1ece8 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -437,7 +437,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 	iobase += UNIOXX5_SUBDEV_BASE;
 	n_subd = 0;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
+	/* getting number of subdevices with types 'g01' */
 	for (i = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
-- 
1.7.9.5

