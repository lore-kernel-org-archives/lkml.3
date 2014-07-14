Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaGNSMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:12:38 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:45754 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaGNSMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:12:30 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] doc: cpu-hotplug.txt: Minor grammar fix
Date: Mon, 14 Jul 2014 14:12:51 -0400
Message-Id: <1405361572-8277-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix minor grammar in sentence

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/cpu-hotplug.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index a0b005d..2ec86f6 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -383,7 +383,7 @@ A: The following are what is required for CPU hotplug infrastructure to work
                           dead routine is called to be sure positively.
 
 Q: I need to ensure that a particular cpu is not removed when there is some
-   work specific to this cpu is in progress.
+   work specific to this cpu in progress.
 A: There are two ways.  If your code can be run in interrupt context, use
    smp_call_function_single(), otherwise use work_on_cpu().  Note that
    work_on_cpu() is slow, and can fail due to out of memory:
-- 
1.9.1

