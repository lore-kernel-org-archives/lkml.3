Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaBURCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:02:07 -0500
Received: from mail.zhinst.com ([212.126.164.98]:58184 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbaBURCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:02:05 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 12:02:05 EST
From: Tobias Klauser <tklauser@distanz.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Change mailing list address for Altera UART drivers
Date: Fri, 21 Feb 2014 17:56:58 +0100
Message-Id: <1393001818-29521-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nios2-dev list has been moved to the RocketBoards infrastructure, so
adjust the address accordingly.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca47282..5a4fdfd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -538,7 +538,7 @@ F:	arch/alpha/
 ALTERA UART/JTAG UART SERIAL DRIVERS
 M:	Tobias Klauser <tklauser@distanz.ch>
 L:	linux-serial@vger.kernel.org
-L:	nios2-dev@sopc.et.ntust.edu.tw (moderated for non-subscribers)
+L:	nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/tty/serial/altera_uart.c
 F:	drivers/tty/serial/altera_jtaguart.c
-- 
1.7.9.5


