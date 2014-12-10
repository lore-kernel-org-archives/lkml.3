Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbaLJRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:37:40 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39483 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbaLJRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:37:39 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: rjw@rjwysocki.net, daniel.lezcano@linaro.org
Cc: linux-kernel@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] drivers: cpuidle: Added a blank line after declarations
Date: Wed, 10 Dec 2014 23:07:24 +0530
Message-Id: <1418233044-12059-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: Missing blank line after declarations

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/cpuidle/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index e431d11..7fa66f6 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -144,6 +144,7 @@ static inline void __cpuidle_unset_driver(struct cpuidle_driver *drv)
 static void cpuidle_setup_broadcast_timer(void *arg)
 {
 	int cpu = smp_processor_id();
+
 	clockevents_notify((long)(arg), &cpu);
 }
 
-- 
1.9.1

