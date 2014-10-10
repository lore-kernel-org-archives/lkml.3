Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaJJW04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:26:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40499 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaJJW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:26:55 -0400
X-Auth-Info: tJLxxOo/i3Gn7MPgqPE5/byj41cBANv9tMJJEYy0e2g=
From: Marek Vasut <marex@denx.de>
To: linux-doc@vger.kernel.org
Cc: Olaf Mandel <o.mandel@menlosystems.com>, Marek Vasut <marex@denx.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] doc: Fix comparison operator
Date: Sat, 11 Oct 2014 00:26:46 +0200
Message-Id: <1412980006-6657-1-git-send-email-marex@denx.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Mandel <o.mandel@menlosystems.com>

Align the documentation with the include/linux/etherdevice.h ,
which is where this example comes from. The return value from
the check was inverted in the documentation.

Signed-off-by: Olaf Mandel <o.mandel@menlosystems.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/unaligned-memory-access.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.txt
index a445da0..3f76c0c 100644
--- a/Documentation/unaligned-memory-access.txt
+++ b/Documentation/unaligned-memory-access.txt
@@ -151,7 +151,7 @@ bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
 #else
 	const u16 *a = (const u16 *)addr1;
 	const u16 *b = (const u16 *)addr2;
-	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;
+	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) == 0;
 #endif
 }
 
-- 
2.0.0

