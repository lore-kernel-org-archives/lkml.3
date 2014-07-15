Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaGORI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:29 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61735 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaGORCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:20 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 77/94] Documentation/Changes: clean up mcelog paragraph
Date: Tue, 15 Jul 2014 20:01:32 +0300
Message-Id: <1405443709-15288-77-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

The paragraph on mcelog currently describes kernel v2.6.31. In that
kernel the mce code (for i386, that is) was in transition. Ever since
v2.6.32 the situation is much simpler (eg, mcelog is now needed to
process events on almost all x86 machines, i386 and x86-64). Since this
"document is designed to provide a list of the minimum levels of
software necessary to run the 3.0 kernels" let's just describe that
situation.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 Documentation/Changes |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 2254db0..227bec8 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -280,12 +280,9 @@ that is possible.
 mcelog
 ------
 
-In Linux 2.6.31+ the i386 kernel needs to run the mcelog utility
-as a regular cronjob similar to the x86-64 kernel to process and log
-machine check events when CONFIG_X86_NEW_MCE is enabled. Machine check
-events are errors reported by the CPU. Processing them is strongly encouraged.
-All x86-64 kernels since 2.6.4 require the mcelog utility to
-process machine checks.
+On x86 kernels the mcelog utility is needed to process and log machine check
+events when CONFIG_X86_MCE is enabled. Machine check events are errors reported
+by the CPU. Processing them is strongly encouraged.
 
 Getting updated software
 ========================
-- 
1.7.10.4

