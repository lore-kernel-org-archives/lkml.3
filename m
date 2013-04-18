Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967114Ab3DRVRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:17:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34839 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751781Ab3DRVRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:17:15 -0400
Message-ID: <1366319834.2119.27.camel@joe-AO722>
Subject: [PATCH usb-next] usb: storage: Fix link error
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>
Date: Thu, 18 Apr 2013 14:17:14 -0700
In-Reply-To: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
References: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix allmodconfig link error introduced by commit 75b9130e8a
("usb: storage: Add usb_stor_dbg, reduce object size")

Export the symbol usb_stor_dbg.
Add export.h

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/storage/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index b428129..29fe08f 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/cdrom.h>
+#include <linux/export.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -193,3 +194,4 @@ int usb_stor_dbg(const char *fmt, ...)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(usb_stor_dbg);


