Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3HPSHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:07:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59686 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3HPSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:07:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: laforge@gnumonks.org
Subject: [PATCH] Omnikey Cardman 4000: pull in ioctl.h in user header
Date: Fri, 16 Aug 2013 14:07:09 -0400
Message-Id: <1376676429-3953-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file uses the ioctl helpers (_IOR/_IOW/etc...), so include ioctl.h
for the definitions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/uapi/linux/cm4000_cs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/cm4000_cs.h b/include/uapi/linux/cm4000_cs.h
index bc51f77..1217f75 100644
--- a/include/uapi/linux/cm4000_cs.h
+++ b/include/uapi/linux/cm4000_cs.h
@@ -2,6 +2,7 @@
 #define _UAPI_CM4000_H_
 
 #include <linux/types.h>
+#include <linux/ioctl.h>
 
 #define	MAX_ATR			33
 
-- 
1.8.3.2

