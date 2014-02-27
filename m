Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaB0LwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:52:15 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48646 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0LwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:52:13 -0500
Date: Thu, 27 Feb 2014 17:22:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        josh@joshtriplett.org
Subject: [PATCH 19/46] kernel: Include appropriate header file in
 locking/rtmutex-tester.c
Message-ID: <46dcaa2d2731c0f65aa9ef667b7ad49264bbf6c6.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file kernel/locking/rtmutex_common.h in
kernel/locking/rtmutex-tester.c because it has prototype declaration of
function define din kernel/locking/rtmutex-tester.c.

This eliminates the following warning in
kernel/locking/rtmutex-tester.c:
kernel/locking/rtmutex-tester.c:139:6: warning: no previous prototype for ‘schedule_rt_mutex_test’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/locking/rtmutex-tester.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rtmutex-tester.c b/kernel/locking/rtmutex-tester.c
index 1d96dd0..b17eef2 100644
--- a/kernel/locking/rtmutex-tester.c
+++ b/kernel/locking/rtmutex-tester.c
@@ -16,7 +16,7 @@
 #include <linux/freezer.h>
 #include <linux/stat.h>
 
-#include "rtmutex.h"
+#include "rtmutex_common.h"
 
 #define MAX_RT_TEST_THREADS	8
 #define MAX_RT_TEST_MUTEXES	8
-- 
1.7.9.5

