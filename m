Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaHDHjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:39:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35343 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbaHDHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:39:22 -0400
X-IronPort-AV: E=Sophos;i="5.04,260,1406563200"; 
   d="scan'208";a="34137949"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: <dzickus@redhat.com>, <mingo@redhat.com>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] watchdog: remove unnecessary head files
Date: Mon, 4 Aug 2014 15:36:18 +0800
Message-ID: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
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

