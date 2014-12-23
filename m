Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaLWXHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbaLWXGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:06:55 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] samples/livepatch: fix usage example comments
Date: Tue, 23 Dec 2014 17:06:43 -0600
Message-Id: <51835fd54ceacfd68a0c044dd9b625506cc733b8.1419375802.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few typos in the livepatch-sample.c usage example comments and add
some whitespace to make the comments a little more legible.

Reported-by: Udo Seidel <udoseidel@gmx.de>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 samples/livepatch/livepatch-sample.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index 21f159d..fb8c861 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -26,12 +26,16 @@
  * kernel boot cmdline when /proc/cmdline is read.
  *
  * Example:
+ *
  * $ cat /proc/cmdline
  * <your cmdline>
+ *
  * $ insmod livepatch-sample.ko
  * $ cat /proc/cmdline
  * this has been live patched
- * $ echo 0 > /sys/kernel/livepatch/klp_sample/enabled
+ *
+ * $ echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
+ * $ cat /proc/cmdline
  * <your cmdline>
  */
 
-- 
2.1.0

