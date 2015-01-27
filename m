Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbbA0Rtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:49:39 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:49265 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533AbbA0Rte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:34 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/9] staging: comedi: usbdux: include new "comedi_usb.h" header
Date: Tue, 27 Jan 2015 17:49:05 +0000
Message-Id: <1422380949-5994-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
References: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the new "../comedi_usb.h" header instead of <linux/usb.h> and
"../comedidev.h", which will now get included indirectly.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/usbdux.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 0683d6a..1cd7403 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -80,11 +80,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/usb.h>
 #include <linux/fcntl.h>
 #include <linux/compiler.h>
 
-#include "../comedidev.h"
+#include "../comedi_usb.h"
 
 #include "comedi_fc.h"
 
-- 
2.1.4

