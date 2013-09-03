Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3ICOoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:44:22 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49074 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3ICOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:44:21 -0400
Date: Tue, 3 Sep 2013 16:44:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 cleanup for v3.12
Message-ID: <20130903144417.GA28840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: 062fe8fe511e7f771ef1dc824eaf996ba50a694b x86, boot: Fix warning due to undeclared strlen()

A small cleanup.

 Thanks,

	Ingo

------------------>
Fred Chen (1):
      x86, boot: Fix warning due to undeclared strlen()


 arch/x86/boot/boot.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 5b75319..ef72bae 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -355,6 +355,7 @@ int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
+size_t strlen(const char *s);
 
 /* tty.c */
 void puts(const char *);
