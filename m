Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3EGOSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:18:09 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59341 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752699Ab3EGOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 14/15] staging/sb105x: remove asm/segment.h dependency
Date: Tue,  7 May 2013 16:18:22 +0200
Message-Id: <1367936303-13386-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

sb105x doesn't seem to actually need <asm/segment.h> (builds on x86
without it) and ppc/ppc64 doesn't provide it so it fails to build there.

This patch removes the dependency.

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/sb105x/sb_pci_mp.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.h b/drivers/staging/sb105x/sb_pci_mp.h
index a15f470..11d9299 100644
--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -19,7 +19,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/segment.h>
 #include <asm/serial.h>
 #include <linux/interrupt.h>
 
-- 
1.8.2.1

