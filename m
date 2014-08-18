Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaHRSEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:04:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:04:00 -0400
Date: Mon, 18 Aug 2014 11:03:38 -0700
From: tip-bot for chai wen <tipbot@zytor.com>
Message-ID: <tip-f530504a063cfa028971e4b26ea8e0c32908de25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        chaiw.fnst@cn.fujitsu.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chaiw.fnst@cn.fujitsu.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1407768567-171794-2-git-send-email-dzickus@redhat.com>
References: <1407768567-171794-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/watchdog] watchdog: Remove unnecessary header files
Git-Commit-ID: f530504a063cfa028971e4b26ea8e0c32908de25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f530504a063cfa028971e4b26ea8e0c32908de25
Gitweb:     http://git.kernel.org/tip/f530504a063cfa028971e4b26ea8e0c32908de25
Author:     chai wen <chaiw.fnst@cn.fujitsu.com>
AuthorDate: Mon, 11 Aug 2014 10:49:23 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Aug 2014 11:17:46 +0200

watchdog: Remove unnecessary header files

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: pbonzini@redhat.com
Link: http://lkml.kernel.org/r/1407768567-171794-2-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c | 5 -----
 1 file changed, 5 deletions(-)

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
