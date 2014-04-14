Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaDNQck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:32:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbaDNQcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:32:16 -0400
Date: Mon, 14 Apr 2014 18:32:13 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Jiri Kosina <trivial@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tty: Fix help text of SYNCLINK_CS
Message-ID: <20140414183213.64d9fae2@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling SYNCLINK_CS as a module builds synclink_cs, not synclinkmp.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
Who wants to pick this?

 drivers/char/pcmcia/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.15-rc1.orig/drivers/char/pcmcia/Kconfig	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc1/drivers/char/pcmcia/Kconfig	2014-04-14 18:24:39.754352894 +0200
@@ -15,7 +15,7 @@ config SYNCLINK_CS
 
 	  This driver may be built as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclinkmp.  If you want to do that, say M
+	  The module will be called synclink_cs.  If you want to do that, say M
 	  here.
 
 config CARDMAN_4000


-- 
Jean Delvare
SUSE L3 Support
