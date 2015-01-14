Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbbANIW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:22:56 -0500
Received: from mx02.posteo.de ([89.146.194.165]:52057 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbbANIWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:22:25 -0500
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: fix coding style error
Date: Wed, 14 Jan 2015 09:20:42 +0100
Message-Id: <1421223642-4465-1-git-send-email-patrick.boettcher@posteo.de>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple style fix - 80 char limit was exceeded.

Context: eudyptula challenge (http://eudyptula-challenge.org/)

Signed-off-by: Patrick Boettcher <patrick.boettcher@posteo.de>

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Tapasweni Pathak <tapaswenipathak@gmail.com>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.1.4

