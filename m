Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbbAOOzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:55:32 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64778 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbAOOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:55:29 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: jonas@southpole.se, linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] openrisc: Remove unnecessary KERN_INFO in time.c
Date: Thu, 15 Jan 2015 23:55:18 +0900
Message-Id: <1421333718-20431-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_INFO in time.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/openrisc/kernel/time.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/openrisc/kernel/time.c b/arch/openrisc/kernel/time.c
index 7c52e94..3b50ffd 100644
--- a/arch/openrisc/kernel/time.c
+++ b/arch/openrisc/kernel/time.c
@@ -53,20 +53,20 @@ static void openrisc_timer_set_mode(enum clock_event_mode mode,
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		pr_debug(KERN_INFO "%s: periodic\n", __func__);
+		pr_debug("%s: periodic\n", __func__);
 		BUG();
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		pr_debug(KERN_INFO "%s: oneshot\n", __func__);
+		pr_debug("%s: oneshot\n", __func__);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
-		pr_debug(KERN_INFO "%s: unused\n", __func__);
+		pr_debug("%s: unused\n", __func__);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		pr_debug(KERN_INFO "%s: shutdown\n", __func__);
+		pr_debug("%s: shutdown\n", __func__);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
-		pr_debug(KERN_INFO "%s: resume\n", __func__);
+		pr_debug("%s: resume\n", __func__);
 		break;
 	}
 }
-- 
2.3.0.rc0

