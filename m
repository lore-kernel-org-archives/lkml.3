Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3LGGHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 01:07:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45215 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3LGGHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 01:07:37 -0500
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 14:07:36 +0800
Message-ID: <CAPgLHd8YaiM_VQZ=6N_ujfJJKWeYVK6S96w5Kv3ikj1b3jyoLA@mail.gmail.com>
Subject: [PATCH -next] sysfs, kernfs: remove duplicated include from file.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, tj@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/kernfs/file.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 990c97f..4a5863b 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -13,7 +13,6 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/pagemap.h>
-#include <linux/poll.h>
 #include <linux/sched.h>
 
 #include "kernfs-internal.h"

