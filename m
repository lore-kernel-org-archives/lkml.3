Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbbALQb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:31:56 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32943 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbALQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:31:54 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH] staging: android: Fixed checkpatch.pl warning
Date: Mon, 12 Jan 2015 17:31:21 +0100
Message-Id: <1421080281-6889-2-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421080281-6889-1-git-send-email-moritz.fischer@ettus.com>
References: <1421080281-6889-1-git-send-email-moritz.fischer@ettus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file triggered the following warning:

WARNING: line over 80 characters

Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
---
 drivers/staging/android/sync_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
index 1532a86..9a2aaf8 100644
--- a/drivers/staging/android/sync_debug.c
+++ b/drivers/staging/android/sync_debug.c
@@ -96,7 +96,8 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 		   sync_status_str(status));
 
 	if (status <= 0) {
-		struct timespec64 ts64 = ktime_to_timespec64(pt->base.timestamp);
+		struct timespec64 ts64 =
+		    ktime_to_timespec64(pt->base.timestamp);
 
 		seq_printf(s, "@%lld.%09ld", (s64)ts64.tv_sec, ts64.tv_nsec);
 	}
-- 
1.9.3

