Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3KZLAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:00:20 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:53508 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3KZLAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:00:17 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] MAINTAINERS: Add an entry for the Macintosh HFSPlus Filesystem
Date: Tue, 26 Nov 2013 11:59:53 +0100
Message-Id: <1385463593-16709-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vyacheslav Dubeyko kindly offered to become the maintainer.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Orphan -> maintained by Vyacheslav Dubeyko

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 746581df3395..a92ac8f6758c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3937,6 +3937,13 @@ S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
+HFSPLUS FILESYSTEM
+M:	Vyacheslav Dubeyko <slava@dubeyko.com>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/filesystems/hfsplus.txt
+F:	fs/hfsplus/
+
 HGA FRAMEBUFFER DRIVER
 M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
 L:	linux-nvidia@lists.surfsouth.com
-- 
1.7.9.5

