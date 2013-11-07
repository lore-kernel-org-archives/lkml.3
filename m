Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3KGR6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:58:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3KGR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:58:17 -0500
Message-ID: <527BD4B6.7040107@infradead.org>
Date: Thu, 07 Nov 2013 09:58:14 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
Subject: [PATCH bz 60724] tty/serial/8250: fix typo in help text
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Commit 9326b047e4fd4a8da72e59d913214a1803e9709c includes a typo
of "8350_core" instead of "8250_core", so correct it.

Fixes kernel bugzilla #60724:
  https://bugzilla.kernel.org/show_bug.cgi?id=60724

Reported-by:  Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-312.orig/drivers/tty/serial/8250/Kconfig
+++ lnx-312/drivers/tty/serial/8250/Kconfig
@@ -41,7 +41,7 @@ config SERIAL_8250_DEPRECATED_OPTIONS
 	  accept kernel parameters in both forms like 8250_core.nr_uarts=4 and
 	  8250.nr_uarts=4. We now renamed the module back to 8250, but if
 	  anybody noticed in 3.7 and changed their userspace we still have to
-	  keep the 8350_core.* options around until they revert the changes
+	  keep the 8250_core.* options around until they revert the changes
 	  they already did.
 
 	  If 8250 is built as a module, this adds 8250_core alias instead. 
