Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBXJtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:49:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52642 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBXJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:49:03 -0500
From: David Roddick <dgroddick@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        David Roddick <dgroddick@gmail.com>
Subject: [PATCH] Staging: comedi: fix coding style issues in poc.c
Date: Mon, 24 Feb 2014 20:48:47 +1100
Message-Id: <1393235327-8546-1-git-send-email-dgroddick@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary spaces after function pointer names and corrected multi-line wrap alignment

Signed-off-by: David Roddick <dgroddick@gmail.com>
---
 drivers/staging/comedi/drivers/poc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 2ae4ee1..514ccd8 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -36,16 +36,16 @@ Configuration options:
 struct boarddef_struct {
 	const char *name;
 	unsigned int iosize;
-	int (*setup) (struct comedi_device *);
+	int (*setup)(struct comedi_device *);
 	int type;
 	int n_chan;
 	int n_bits;
-	int (*winsn) (struct comedi_device *, struct comedi_subdevice *,
-		      struct comedi_insn *, unsigned int *);
-	int (*rinsn) (struct comedi_device *, struct comedi_subdevice *,
-		      struct comedi_insn *, unsigned int *);
-	int (*insnbits) (struct comedi_device *, struct comedi_subdevice *,
-			 struct comedi_insn *, unsigned int *);
+	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
+		struct comedi_insn *, unsigned int *);
+	int (*rinsn)(struct comedi_device *, struct comedi_subdevice *,
+		struct comedi_insn *, unsigned int *);
+	int (*insnbits)(struct comedi_device *, struct comedi_subdevice *,
+		struct comedi_insn *, unsigned int *);
 	const struct comedi_lrange *range;
 };
 
-- 
1.8.5.3

