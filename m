Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbbA0Rte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:49:34 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:43275 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442AbbA0Rtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:32 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] staging: comedi: dt9812: include new "comedi_usb.h" header
Date: Tue, 27 Jan 2015 17:49:03 +0000
Message-Id: <1422380949-5994-4-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/dt9812.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 06c601d..e11c216 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -42,9 +42,8 @@ for my needs.
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/uaccess.h>
-#include <linux/usb.h>
 
-#include "../comedidev.h"
+#include "../comedi_usb.h"
 
 #define DT9812_DIAGS_BOARD_INFO_ADDR	0xFBFF
 #define DT9812_MAX_WRITE_CMD_PIPE_SIZE	32
-- 
2.1.4

