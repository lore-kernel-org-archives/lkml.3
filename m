Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaIDLEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:04:33 -0400
Received: from 59.163.222.150.static.vsnl.net.in ([59.163.222.150]:51165 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbaIDLEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:04:32 -0400
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 07:04:32 EDT
Date: Mon, 1 Sep 2014 08:47:12 -0400
From: Dipak Zope <dipakzope.kernel.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: staging: android: uapi: binder.h: Used __packed instead of
 __attribute__((packed))
Message-ID: <20140901124712.GA48606@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dipak Zope <dipakzope.kernel.org@gmail.com>
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
1.8.3.1

