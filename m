Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaCYAYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:24:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61448 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCYAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:24:35 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arve@android.com, gregkh@linuxfoundation.org,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 2/2] staging: binder: reduce line size
Date: Tue, 25 Mar 2014 01:24:25 +0100
Message-Id: <1395707065-23808-2-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395707065-23808-1-git-send-email-mathieu.maret@gmail.com>
References: <1395707065-23808-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/android/binder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 9418086..4e51034 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2688,7 +2688,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version __user *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			&((struct binder_version __user *)ubuf)->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
-- 
1.9.1

