Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbAVJd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:33:26 -0500
Received: from 195-154-87-184.rev.poneytelecom.eu ([195.154.87.184]:53007 "EHLO
	gaby.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbAVJdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:33:18 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 04:33:18 EST
From: Gabriel Laskar <gabriel@lse.epita.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: ashmem - missing linux/types.h in header.
Date: Thu, 22 Jan 2015 10:24:49 +0100
Message-Id: <1421918692-5872-1-git-send-email-gabriel@lse.epita.fr>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ashmem_pin uses __u32 types that are defined in linux/types.h.

Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
---
 drivers/staging/android/uapi/ashmem.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/uapi/ashmem.h b/drivers/staging/android/uapi/ashmem.h
index ba4743c..13df42d 100644
--- a/drivers/staging/android/uapi/ashmem.h
+++ b/drivers/staging/android/uapi/ashmem.h
@@ -13,6 +13,7 @@
 #define _UAPI_LINUX_ASHMEM_H
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 #define ASHMEM_NAME_LEN		256
 
-- 
2.2.2

