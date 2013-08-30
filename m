Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3H3Qmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:42:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47585 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab3H3QlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:41:07 -0400
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
Subject: [PATCH 5/7] watchdog: Drop references to H8300 architecture
Date: Fri, 30 Aug 2013 09:40:40 -0700
Message-Id: <1377880842-6835-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture is gone.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig  |    2 --
 drivers/watchdog/Makefile |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 362085d..08a8a4d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -408,8 +408,6 @@ config BFIN_WDT
 
 # FRV Architecture
 
-# H8300 Architecture
-
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 2f26a0b..3989d3e 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -65,8 +65,6 @@ obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
 
 # FRV Architecture
 
-# H8300 Architecture
-
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
-- 
1.7.9.7

