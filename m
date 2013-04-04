Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab3DDBRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:17:24 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:41605 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762721Ab3DDBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:17:22 -0400
MIME-Version: 1.0
Date: Thu, 4 Apr 2013 09:17:20 +0800
Message-ID: <CAPgLHd-M-q-xf+mp3VTAabxXS3bOjZ4g8EWLeE2NdjC2O7qCSA@mail.gmail.com>
Subject: [PATCH -next] audit: remove duplicated include from audit.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/audit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 488f85f..9377913 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,7 +58,6 @@
 #ifdef CONFIG_SECURITY
 #include <linux/security.h>
 #endif
-#include <net/netlink.h>
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>

