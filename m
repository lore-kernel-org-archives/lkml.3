Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaJAPpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:45:04 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63777 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaJAPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:45:01 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, hannes@cmpxchg.org
Subject: [PATCH] mm: memcontrol Use #include <linux/uaccess.h>
Date: Wed,  1 Oct 2014 16:44:56 +0100
Message-Id: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove asm headers for linux headers

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 085dc6d..51dbe80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -56,14 +56,14 @@
 #include <linux/oom.h>
 #include <linux/lockdep.h>
 #include <linux/file.h>
+#include <linux/uaccess.h>
+
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include <net/tcp_memcontrol.h>
 #include "slab.h"
 
-#include <asm/uaccess.h>
-
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
-- 
1.9.1

