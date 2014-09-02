Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaIBTYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:24:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53255 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaIBTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:24:10 -0400
From: Grzegorz Swirski <grzegorz@swirski.name>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, dipakzope.kernel.org@gmail.com, daniel@ffwll.ch,
        waydi1@gmail.com, grzegorz@swirski.name, alistair.strachan@imgtec.com,
        pkamliya@codeaurora.org, maarten.lankhorst@canonical.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: use braces on all arms of if
Date: Tue,  2 Sep 2014 20:24:04 +0100
Message-Id: <1409685844-827-1-git-send-email-grzegorz@swirski.name>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grzegorz Swirski <grzegorz@swirski.name>
---
 drivers/staging/android/sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 0d37495..c5255dc 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -387,9 +387,9 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 					       timeout);
 	trace_sync_wait(fence, 0);
 
-	if (ret < 0)
+	if (ret < 0) {
 		return ret;
-	else if (ret == 0) {
+	} else if (ret == 0) {
 		if (timeout) {
 			pr_info("fence timeout on [%p] after %dms\n", fence,
 				jiffies_to_msecs(timeout));
-- 
1.9.1

