Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaF2KNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:13:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53262 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaF2KNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:13:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -trivial] Documentation/kernel-parameters: Remove obsolete ip2=
Date: Sun, 29 Jun 2014 12:13:05 +0200
Message-Id: <1404036785-31297-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handling of ip2= in drivers/char/ip2/ip2base.c was moved to
drivers/char/ip2/ip2main.c in commit
47babd4c6a16915aeb15d4216d91f03910572982 ("Char: merge ip2main and
ip2base").

The ip2 driver was demoted to staging in commit
4a6514e6d096716fb7bedf238efaaca877e2a7e8 ("tty: move obsolete and broken
tty drivers to drivers/staging/tty/"), and finally deleted in commit
51c9d654c2def97827395a7fbfd0c6f865c26544 ("Staging: delete tty drivers").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kernel-parameters.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 884904975d0b..86fc5ea2e21a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1416,10 +1416,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ip=		[IP_PNP]
 			See Documentation/filesystems/nfs/nfsroot.txt.
 
-	ip2=		[HW] Set IO/IRQ pairs for up to 4 IntelliPort boards
-			See comment before ip2_setup() in
-			drivers/char/ip2/ip2base.c.
-
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
-- 
1.9.1

