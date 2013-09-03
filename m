Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3ICOmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:42:31 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64317 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3ICOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:42:29 -0400
Date: Tue, 3 Sep 2013 16:42:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot change for v3.12
Message-ID: <20130903144226.GA28656@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   HEAD: 5b8fafcac6242bf914334d3ae9dbe921ad8d4634 x86/boot: Fix a sanity check in printf.c

Small cleanup.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      x86/boot: Fix a sanity check in printf.c


 arch/x86/boot/printf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
index cdac91c..565083c 100644
--- a/arch/x86/boot/printf.c
+++ b/arch/x86/boot/printf.c
@@ -55,7 +55,7 @@ static char *number(char *str, long num, int base, int size, int precision,
 	locase = (type & SMALL);
 	if (type & LEFT)
 		type &= ~ZEROPAD;
-	if (base < 2 || base > 36)
+	if (base < 2 || base > 16)
 		return NULL;
 	c = (type & ZEROPAD) ? '0' : ' ';
 	sign = 0;
