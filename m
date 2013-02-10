Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3BJGA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 01:00:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62291 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3BJF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:49 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux@openrisc.net
Subject: [PATCH 13/16] openrisc idle: delete pm_idle
Date: Sun, 10 Feb 2013 00:58:20 -0500
Message-Id: <06f69fdb400f9850337c1f23a1dabca0a2c39cbb.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

pm_idle() on openrisc was dead code.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/idle.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index 7d618fe..5e8a3b6 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -39,11 +39,6 @@
 
 void (*powersave) (void) = NULL;
 
-static inline void pm_idle(void)
-{
-	barrier();
-}
-
 void cpu_idle(void)
 {
 	set_thread_flag(TIF_POLLING_NRFLAG);
-- 
1.8.1.3.535.ga923c31

