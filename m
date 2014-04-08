Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbaDHSCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:02:12 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39557 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbaDHSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:02:08 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging:android:uapi:binder.h __packed
Date: Tue,  8 Apr 2014 19:02:04 +0100
Message-Id: <1396980124-4679-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: __packed is preferred over __attribute__((packed))

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/android/uapi/binder.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
index 904adb7..dba4cef 100644
--- a/drivers/staging/android/uapi/binder.h
+++ b/drivers/staging/android/uapi/binder.h
@@ -169,7 +169,7 @@ struct binder_ptr_cookie {
 struct binder_handle_cookie {
 	__u32 handle;
 	binder_uintptr_t cookie;
-} __attribute__((packed));
+} __packed;
 
 struct binder_pri_desc {
 	__s32 priority;
-- 
1.8.3.2

