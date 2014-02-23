Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaBWXCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:02:37 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51110 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaBWXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:02:36 -0500
From: David Roddick <dgroddick@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        David Roddick <dgroddick@gmail.com>
Subject: [PATCH] Staging: comedi: Fix coding style issue in poc.c This is a patch to remove unneccessary space after function pointer name found with checkpatch.pl 
Date: Mon, 24 Feb 2014 10:02:25 +1100
Message-Id: <1393196545-9723-1-git-send-email-dgroddick@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Signed-off-by: David Roddick <dgroddick@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/poc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 2ae4ee1..22c7392 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -36,15 +36,15 @@ Configuration options:
 struct boarddef_struct {
 	const char *name;
 	unsigned int iosize;
-	int (*setup) (struct comedi_device *);
+	int (*setup)(struct comedi_device *);
 	int type;
 	int n_chan;
 	int n_bits;
-	int (*winsn) (struct comedi_device *, struct comedi_subdevice *,
+	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
 		      struct comedi_insn *, unsigned int *);
-	int (*rinsn) (struct comedi_device *, struct comedi_subdevice *,
+	int (*rinsn)(struct comedi_device *, struct comedi_subdevice *,
 		      struct comedi_insn *, unsigned int *);
-	int (*insnbits) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insnbits)(struct comedi_device *, struct comedi_subdevice *,
 			 struct comedi_insn *, unsigned int *);
 	const struct comedi_lrange *range;
 };
-- 
1.8.5.3

