Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaBUE7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:59:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54946 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaBUE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:59:48 -0500
From: behanw@converseincode.com
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] Documentation: LLVMLinux: Update Documentation/dontdiff
Date: Thu, 20 Feb 2014 20:59:42 -0800
Message-Id: <1392958782-27426-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Clang has a few other kinds of derived files which shouldn't be added to a
patch. Add them to the Documentation/dontdiff file to prevent this.

Author:  PaX Team <pageexec@freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org
Merge:   Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 Documentation/dontdiff | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index b89a739..9de9813 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -1,5 +1,6 @@
 *.a
 *.aux
+*.bc
 *.bin
 *.bz2
 *.cis
@@ -21,6 +22,7 @@
 *.i
 *.jpeg
 *.ko
+*.ll
 *.log
 *.lst
 *.lzma
@@ -35,6 +37,7 @@
 *.out
 *.patch
 *.pdf
+*.plist
 *.png
 *.pot
 *.ps
-- 
1.8.3.2

