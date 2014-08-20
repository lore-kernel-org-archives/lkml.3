Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaHTUaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:30:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63554 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaHTUaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:30:01 -0400
From: Jim Davis <jim.epost@gmail.com>
To: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, sj38.park@gmail.com, sfr@canb.auug.org.au,
        Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] Documentation: remove outdated references to the linux-next wiki
Date: Wed, 20 Aug 2014 13:29:41 -0700
Message-Id: <1408566581-14109-1-git-send-email-jim.epost@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux-next wiki at http://linux.f-seidel.de/linux-next/pmwiki has
been gone for several months now.

Signed-off-by: Jim Davis <jim.epost@gmail.com>
---
 Documentation/HOWTO                            | 1 -
 Documentation/development-process/2.Process    | 4 ----
 Documentation/development-process/8.Conclusion | 4 ----
 3 files changed, 9 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 57cf5efb044d..93aa8604630e 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -324,7 +324,6 @@ tree, they need to be integration-tested.  For this purpose, a special
 testing repository exists into which virtually all subsystem trees are
 pulled on an almost daily basis:
 	http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git
-	http://linux.f-seidel.de/linux-next/pmwiki/
 
 This way, the -next kernel gives a summary outlook onto what will be
 expected to go into the mainline kernel at the next merge period.
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 2e0617936e8f..c24e156a6118 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -289,10 +289,6 @@ lists when they are assembled; they can be downloaded from:
 
 	http://www.kernel.org/pub/linux/kernel/next/
 
-Some information about linux-next has been gathered at:
-
-	http://linux.f-seidel.de/linux-next/pmwiki/
-
 Linux-next has become an integral part of the kernel development process;
 all patches merged during a given merge window should really have found
 their way into linux-next some time before the merge window opens.
diff --git a/Documentation/development-process/8.Conclusion b/Documentation/development-process/8.Conclusion
index 1990ab4b4949..caef69022e9c 100644
--- a/Documentation/development-process/8.Conclusion
+++ b/Documentation/development-process/8.Conclusion
@@ -22,10 +22,6 @@ Beyond that, a valuable resource for kernel developers is:
 
 	http://kernelnewbies.org/
 
-Information about the linux-next tree gathers at:
-
-	http://linux.f-seidel.de/linux-next/pmwiki/
-
 And, of course, one should not forget http://kernel.org/, the definitive
 location for kernel release information.
 
-- 
2.1.0

