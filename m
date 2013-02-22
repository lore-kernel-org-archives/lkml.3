Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3BVDhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:37:21 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51646 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3BVDhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:37:18 -0500
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 11:37:17 +0800
Message-ID: <CAPgLHd_EoMHkhnPZfcrmB4fNwOY9Rw5bHbeFyqSQJXqB7hCqoA@mail.gmail.com>
Subject: [PATCH -next] exit: remove duplicated include from exit.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org, msb@chromium.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/exit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 9797ce7..b1ebb10 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -32,7 +32,6 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
-#include <linux/freezer.h>
 #include <linux/cgroup.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>


