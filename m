Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3LBJpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:45:43 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:62646 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3LBJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:45:42 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] tracepoint: Spell Fix: Write "binay" as "binary"
Date: Mon,  2 Dec 2013 15:15:37 +0530
Message-Id: <32a55f133a8138560044ecdac34f0e5aef97ddc3.1385977486.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binary was written as binay, probably by mistake. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tracepoint.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index ebeab36..f0c3e4c 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -274,7 +274,7 @@ static inline void tracepoint_synchronize_unregister(void)
  * For use with the TRACE_EVENT macro:
  *
  * We define a tracepoint, its arguments, its printk format
- * and its 'fast binay record' layout.
+ * and its 'fast binary record' layout.
  *
  * Firstly, name your tracepoint via TRACE_EVENT(name : the
  * 'subsystem_event' notation is fine.
-- 
1.7.12.rc2.18.g61b472e

