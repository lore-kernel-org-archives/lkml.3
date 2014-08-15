Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHORUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:20:45 -0400
Received: from mail-wg0-f68.google.com ([74.125.82.68]:60306 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHORUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:20:44 -0400
From: Purnendu Kapadia <pro8linux@gmail.com>
To: serban.constantinescu@arm.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pro8linux@gmail.com
Subject: [PATCH] staging: android: fix attribute as suggested by checkpatch
Date: Fri, 15 Aug 2014 18:20:30 +0100
Message-Id: <1408123230-11842-1-git-send-email-pro8linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we should use __packed attribute

Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
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
1.9.1

