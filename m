Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJBXo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:44:56 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45242 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJBXoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:44:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Fri, 3 Oct 2014 00:44:52 +0100 (BST)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux-NTFS-Dev@lists.sourceforge.net,
        Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] NTFS: Remove bogus space.
Message-ID: <Pine.LNX.4.64.1410030041150.31680@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ntfs/debug.c:124: WARNING: space prohibited between function name and 
open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
---
Hi Andrew,

Can you please take this simple patch and push it to Linus at some point?

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
index dd6103c..825a54e 100644
--- a/fs/ntfs/debug.c
+++ b/fs/ntfs/debug.c
@@ -112,7 +112,7 @@ void __ntfs_error(const char *function, const struct super_block *sb,
 /* If 1, output debug messages, and if 0, don't. */
 int debug_msgs = 0;
 
-void __ntfs_debug (const char *file, int line, const char *function,
+void __ntfs_debug(const char *file, int line, const char *function,
 		const char *fmt, ...)
 {
 	struct va_format vaf;
