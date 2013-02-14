Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650Ab3BNUcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:32:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58903 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:32:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-doc@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] DocBook: update EXPORT_SYMBOL entry to point at export.h
Date: Thu, 14 Feb 2013 15:32:04 -0500
Message-ID: <1360873924-29368-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we used to get EXPORT_SYMBOL and friends from
module.h but we moved away from that since module.h largely
includes the entire header space one way or another.

As most users just wanted the simple export related macros,
they were spun off into a separate new header -- export.h
Update the docs to reflect that.

Suggested-by: Borislav Petkov <bp@alien8.de>
Cc: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[vectoring via trivial tree as RobL suggested for other doc patch]

 Documentation/DocBook/kernel-hacking.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index eee7142..a23bc37 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -945,7 +945,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
 
   <sect1 id="sym-exportsymbols">
    <title><function>EXPORT_SYMBOL()</function>
-    <filename class="headerfile">include/linux/module.h</filename></title>
+    <filename class="headerfile">include/linux/export.h</filename></title>
 
    <para>
     This is the classic method of exporting a symbol: dynamically
@@ -955,7 +955,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
 
   <sect1 id="sym-exportsymbols-gpl">
    <title><function>EXPORT_SYMBOL_GPL()</function>
-    <filename class="headerfile">include/linux/module.h</filename></title>
+    <filename class="headerfile">include/linux/export.h</filename></title>
 
    <para>
     Similar to <function>EXPORT_SYMBOL()</function> except that the
-- 
1.8.1.2

