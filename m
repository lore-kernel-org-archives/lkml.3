Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3B0GIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:08:15 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34400 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3B0GIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/5] staging: android: lowmemorykiller: Change default debug_level to 1
Date: Tue, 26 Feb 2013 22:07:36 -0800
Message-Id: <1361945258-24420-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

The select...to kill messages are not very useful when not debugging
the lowmemorykiller itself. After the change to check TIF_MEMDIE
instead of using a task notifer this message can also get very
noisy.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2f28763..e0435a9 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -40,7 +40,7 @@
 #include <linux/profile.h>
 #include <linux/notifier.h>
 
-static uint32_t lowmem_debug_level = 2;
+static uint32_t lowmem_debug_level = 1;
 static short lowmem_adj[6] = {
 	0,
 	1,
-- 
1.7.10.4

