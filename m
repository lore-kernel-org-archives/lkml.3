Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaCGAal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:30:41 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47405 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCGAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:30:40 -0500
Date: Thu, 6 Mar 2014 16:30:36 -0800
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, hsweeten@visionengravers.com
Subject: [PATCH] comedi:drivers:poc.c: unnecessary space before function
 pointer arguments
Message-ID: <20140307003034.GA4943@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary space before function pointer arguments.

Signed-off-by: John de la Garza <john@jjdev.com>
---
 drivers/staging/comedi/drivers/poc.c |    8 ++++----
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
1.7.10.4

