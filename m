Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbbA0Rtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:49:31 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:49412 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442AbbA0Rt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:29 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/9] staging: comedi: comedi_usb.c: include new "comedi_usb.h" header
Date: Tue, 27 Jan 2015 17:49:02 +0000
Message-Id: <1422380949-5994-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
References: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the new "comedi_usb.h" header instead of <linux/usb.h> and
"comedidev.h", which will now get included indirectly.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_usb.c b/drivers/staging/comedi/comedi_usb.c
index 0b862a6..68b75e8 100644
--- a/drivers/staging/comedi/comedi_usb.c
+++ b/drivers/staging/comedi/comedi_usb.c
@@ -17,9 +17,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/usb.h>
 
-#include "comedidev.h"
+#include "comedi_usb.h"
 
 /**
  * comedi_to_usb_interface() - comedi_device pointer to usb_interface pointer.
-- 
2.1.4

