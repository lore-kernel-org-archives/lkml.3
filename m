Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaHQSjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:39:53 -0400
Received: from mo-online.de ([89.238.66.174]:52753 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaHQSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:26 -0400
Date: Sun, 17 Aug 2014 20:30:53 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 8/9] [typo] Doc/CodingStyle, BUG-HUNTING, 00-INDEX
Message-ID: <20140817183053.GI4077@mo-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spelling, punctuation, smaller changes

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 Documentation/00-INDEX    |  4 ++--
 Documentation/BUG-HUNTING | 10 +++++-----
 Documentation/CodingStyle |  8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 27e67a9..ab0e924 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -90,7 +90,7 @@ backlight/
 bad_memory.txt
 	- how to use kernel parameters to exclude bad RAM regions.
 basic_profiling.txt
-	- basic instructions for those who wants to profile Linux kernel.
+	- basic instructions for those who want to profile Linux kernel.
 bcache.txt
 	- Block-layer cache on fast SSDs to improve slow (raid) I/O performance.
 binfmt_misc.txt
@@ -242,7 +242,7 @@ io_ordering.txt
 ioctl/
 	- directory with documents describing various IOCTL calls.
 iostats.txt
-	- info on I/O statistics Linux kernel provides.
+	- info on I/O statistics the Linux kernel provides.
 irqflags-tracing.txt
 	- how to use the irq-flags tracing feature.
 isapnp.txt
diff --git a/Documentation/BUG-HUNTING b/Documentation/BUG-HUNTING
index 65022a8..dc33783 100644
--- a/Documentation/BUG-HUNTING
+++ b/Documentation/BUG-HUNTING
@@ -32,8 +32,8 @@ Devices not appearing
 Often this is caused by udev. Check that first before blaming it on the
 kernel.
 
-Finding patch that caused a bug
-===============================
+Finding the patch that caused a bug
+===================================
 
 
 
@@ -157,7 +157,7 @@ in the kernel hacking menu of the menu configuration.) For example:
 
     objdump -r -S -l --disassemble net/dccp/ipv4.o
 
-NB.: you need to be at the top level of the kernel tree for this to pick up
+N.B.: you need to be at the top level of the kernel tree for this to pick up
 your C files.
 
 If you don't have access to the code you can also debug on some crash dumps
@@ -239,8 +239,8 @@ with this look at mm/slab.c and search for POISON_INUSE. When using this an
 Oops will often show the poisoned data instead of zero which is the default.
 
 Once you have worked out a fix please submit it upstream. After all open
-source is about sharing what you do and don't you want to be recognised for
-your genius?
+source is about sharing what you do - and don't you want to be
+recognised for your genius?
 
 Please do read Documentation/SubmittingPatches though to help your code get
 accepted.
diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6b6bef3..8f2581a 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -2,7 +2,7 @@
 		Linux kernel coding style
 
 This is a short document describing the preferred coding style for the
-linux kernel.  Coding style is very personal, and I won't _force_ my
+Linux kernel.  Coding style is very personal, and I won't _force_ my
 views on anybody, but this is what goes for anything that I have to be
 able to maintain, and I'd prefer it for most other things too.  Please
 at least consider the points made here.
@@ -129,7 +129,7 @@ special anyway (you can't nest them in C).
 
 Note that the closing brace is empty on a line of its own, _except_ in
 the cases where it is followed by a continuation of the same statement,
-ie a "while" in a do-statement or an "else" in an if-statement, like
+i.e. a "while" in a do-statement or an "else" in an if-statement, like
 this:
 
 	do {
@@ -327,14 +327,14 @@ useful only for:
      When editing existing code which already uses one or the other set
      of types, you should conform to the existing choices in that code.
 
- (e) Types safe for use in userspace.
+ (e) Types which are safe for use in userspace.
 
      In certain structures which are visible to userspace, we cannot
      require C99 types and cannot use the 'u32' form above. Thus, we
      use __u32 and similar types in all structures which are shared
      with userspace.
 
-Maybe there are other cases too, but the rule should basically be to NEVER
+Maybe there are other cases, too, but the rule should basically be to NEVER
 EVER use a typedef unless you can clearly match one of those rules.
 
 In general, a pointer, or a struct that has elements that can reasonably
-- 
1.8.5.5

