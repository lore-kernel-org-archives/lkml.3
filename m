Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaGQTwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:52:49 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:44900 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaGQTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:52:45 -0400
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, Aditya Kali <adityakali@google.com>
Subject: [PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup namespace
Date: Thu, 17 Jul 2014 12:52:08 -0700
Message-Id: <1405626731-12220-3-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1405626731-12220-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLONE_NEWCGROUP will be used to create new cgroup namespace.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 include/uapi/linux/sched.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..2f90d00 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -21,8 +21,7 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
-   and is now available for re-use. */
+#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
-- 
2.0.0.526.g5318336

