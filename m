Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbbA0RvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:51:12 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:37590 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbbA0Rtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:33 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] staging: comedi: ni_usb6501: include new "comedi_usb.h" header
Date: Tue, 27 Jan 2015 17:49:04 +0000
Message-Id: <1422380949-5994-5-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_usb6501.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_usb6501.c b/drivers/staging/comedi/drivers/ni_usb6501.c
index 3b5a1b9..5f649f8 100644
--- a/drivers/staging/comedi/drivers/ni_usb6501.c
+++ b/drivers/staging/comedi/drivers/ni_usb6501.c
@@ -96,9 +96,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 
-#include "../comedidev.h"
+#include "../comedi_usb.h"
 
 #define	NI6501_TIMEOUT	1000
 
-- 
2.1.4

