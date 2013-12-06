Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab3LFViA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:38:00 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:6770 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730Ab3LFVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:37:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYOAMBColJXQBP1/2dsb2JhbABZJ4Jggjx4E7ZIAgKBIhd0gmYcIxiBAjeIBgHAeo4sZB2EHQOJQI5TAZITgzYvgSw
Date: Fri, 6 Dec 2013 21:38:45 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: npiggin@gmail.com
Subject: [PATCH] RAM block device support module name update in Kconfig
Message-Id: <20131206213845.c2fc58a65acd990b97794414@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAM block device support module name changed to brd.ko 
some years ago with an "rd" alias to match previous module implementation.
This patch updates its Kconfig definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 86b9f37..9ffa90c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -368,7 +368,8 @@ config BLK_DEV_RAM
 	  For details, read <file:Documentation/blockdev/ramdisk.txt>.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called rd.
+	  module will be called brd. An alias "rd" has been defined
+	  for historical reasons.
 
 	  Most normal users won't need the RAM disk functionality, and can
 	  thus say N here.
