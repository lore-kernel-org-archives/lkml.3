Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbaCSBxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:53:37 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45356 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbaCSBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:53:35 -0400
From: behanw@converseincode.com
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu, David.Laight@ACULAB.COM,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2] Documentation: LLVMLinux: Update Documentation/dontdiff
Date: Tue, 18 Mar 2014 18:53:28 -0700
Message-Id: <1395194008-4241-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392958782-27426-1-git-send-email-behanw@converseincode.com>
References: <1392958782-27426-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Clang has a few other kinds of derived files which shouldn't be added to a
patch. Add them to the Documentation/dontdiff file to prevent this.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: PaX Team <pageexec@freemail.hu>
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

