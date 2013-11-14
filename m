Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3KNUkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:40:06 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:38770 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab3KNUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:40:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] MAINTAINERS: Add an entry for the Macintosh HFSPlus Filesystem
Date: Thu, 14 Nov 2013 21:39:23 +0100
Message-Id: <1384461563-4487-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make scripts/get_maintainer.pl output something sensible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I guess it's orphaned, just like HFS?

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f23575ed1416..f1a0e7464ce0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3921,6 +3921,12 @@ S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
+HFSPLUS FILESYSTEM
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
+F:	Documentation/filesystems/hfsplus.txt
+F:	fs/hfsplus/
+
 HGA FRAMEBUFFER DRIVER
 M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
 L:	linux-nvidia@lists.surfsouth.com
-- 
1.7.9.5

