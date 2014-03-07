Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaCGVGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:06:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaCGVGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:06:32 -0500
Date: Fri, 7 Mar 2014 22:06:29 +0100
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] cs5535-mfgpt: Simplify dependencies
Message-ID: <20140307220629.10903b1b@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus and architecture dependencies are already on MFD_CS5535, so
there is no need to repeat them here.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.14-rc5.orig/drivers/misc/Kconfig	2014-03-07 21:57:53.905525392 +0100
+++ linux-3.14-rc5/drivers/misc/Kconfig	2014-03-07 22:04:25.704880611 +0100
@@ -235,7 +235,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI && X86 && MFD_CS5535
+	depends on MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other

-- 
Jean Delvare
SUSE L3 Support
