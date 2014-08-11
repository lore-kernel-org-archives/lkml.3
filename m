Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaHKOvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbaHKOuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:50:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: akpm@linux-foundation.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        chai wen <chaiw.fnst@cn.fujitsu.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/5] watchdog: remove unnecessary head files
Date: Mon, 11 Aug 2014 10:49:23 -0400
Message-Id: <1407768567-171794-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chai wen <chaiw.fnst@cn.fujitsu.com>

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c3319bd..4c2e11c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -15,11 +15,6 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
-- 
1.7.1

