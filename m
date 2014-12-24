Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaLXQeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:34:16 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:49665 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLXQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:34:12 -0500
From: Steve Pennington <sgpenn@gmail.com>
X-Google-Original-From: Steve Pennington < sgpenn@gmail.com >
To: gregkh@linuxfoundation.org, john.stultz@linaro.org,
        maarten.lankhorst@canonical.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, tapaswenipathak@gmail.com,
        peter.senna@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Steve Pennington <sgpenn@gmail.com>
Subject: [PATCH] Staging: android: fix line length coding style issue in sync_debug.c
Date: Wed, 24 Dec 2014 09:33:02 -0600
Message-Id: <1419435182-27322-1-git-send-email-sgpenn@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Pennington <sgpenn@gmail.com>

This is a patch to sync_debug.c that fixes an over 80 character warning found by the checkpatch.pl tool
Signed-off-by: Steve Pennington <sgpenn@gmail.com>
---
 drivers/staging/android/sync_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
index 1532a86..91ed2c4 100644
--- a/drivers/staging/android/sync_debug.c
+++ b/drivers/staging/android/sync_debug.c
@@ -96,7 +96,8 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 		   sync_status_str(status));
 
 	if (status <= 0) {
-		struct timespec64 ts64 = ktime_to_timespec64(pt->base.timestamp);
+		struct timespec64 ts64 =
+			ktime_to_timespec64(pt->base.timestamp);
 
 		seq_printf(s, "@%lld.%09ld", (s64)ts64.tv_sec, ts64.tv_nsec);
 	}
-- 
2.2.1

