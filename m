Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3H3Qmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:42:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46396 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3H3QlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:41:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6/7] Drop MAINTAINERS entry for H8/300
Date: Fri, 30 Aug 2013 09:40:41 -0700
Message-Id: <1377880842-6835-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architecture is gone.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 MAINTAINERS |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8197fbd..62e513e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8482,14 +8482,6 @@ S:	Maintained
 F:	arch/m68k/*/*_no.*
 F:	arch/m68k/include/asm/*_no.*
 
-UCLINUX FOR RENESAS H8/300 (H8300)
-M:	Yoshinori Sato <ysato@users.sourceforge.jp>
-W:	http://uclinux-h8.sourceforge.jp/
-S:	Supported
-F:	arch/h8300/
-F:	drivers/ide/ide-h8300.c
-F:	drivers/net/ethernet/8390/ne-h8300.c
-
 UDF FILESYSTEM
 M:	Jan Kara <jack@suse.cz>
 S:	Maintained
-- 
1.7.9.7

