Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3JSH3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 03:29:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:65051 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3JSH3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 03:29:20 -0400
From: Saumya Ranjan Kuanr <saumyakuanr@gmail.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, saumyakuanr@gmail.com
Subject: [PATCH] cpu-idle: cpuidle-ux500: fixed a coding style issue
Date: Sat, 19 Oct 2013 00:28:48 -0700
Message-Id: <1382167729-21232-1-git-send-email-saumyakuanr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-Antivirus: avast! (VPS 131018-1, 18-10-2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

Signed-off-by: Saumya Ranjan Kuanr<saumyakuanr@gmail.com>
---
 drivers/cpuidle/cpuidle-ux500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-ux500.c b/drivers/cpuidle/cpuidle-ux500.c
index e056465..746d716 100644
--- a/drivers/cpuidle/cpuidle-ux500.c
+++ b/drivers/cpuidle/cpuidle-ux500.c
@@ -102,7 +102,7 @@ static struct cpuidle_driver ux500_idle_driver = {
 			.exit_latency	  = 70,
 			.target_residency = 260,
 			.flags		  = CPUIDLE_FLAG_TIME_VALID |
-			                    CPUIDLE_FLAG_TIMER_STOP,
+						CPUIDLE_FLAG_TIMER_STOP,
 			.name		  = "ApIdle",
 			.desc		  = "ARM Retention",
 		},
--
1.7.9.5

