Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaIUQ16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:27:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61425 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaIUQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:39 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 4/8] cris: time.c: Add missing include file to fix compile error
Date: Sun, 21 Sep 2014 09:27:14 -0700
Message-Id: <1411316838-15135-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compile error.

arch/cris/arch-v32/kernel/time.c: In function ‘reset_watchdog’:
arch/cris/arch-v32/kernel/time.c:121:2:
	error: implicit declaration of function ‘global_page_state’

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/cris/arch-v32/kernel/time.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index ee66866..73745ce 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/cpufreq.h>
+#include <linux/mm.h>
 #include <asm/types.h>
 #include <asm/signal.h>
 #include <asm/io.h>
-- 
1.9.1

