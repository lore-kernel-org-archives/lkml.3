Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaGaD30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:29:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756134AbaGaD3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:29:25 -0400
X-IronPort-AV: E=Sophos;i="5.00,999,1396972800"; 
   d="scan'208";a="33996445"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] smpboot: remove the unneeded declaration for smpboot_thread_data
Date: Thu, 31 Jul 2014 11:30:18 +0800
Message-ID: <1406777421-12830-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smpboot.h doesn't need this declaration, remove it.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/smpboot.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 13e9296..d37dc78 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -4,8 +4,6 @@
 #include <linux/types.h>
 
 struct task_struct;
-/* Cookie handed to the thread_fn*/
-struct smpboot_thread_data;
 
 /**
  * struct smp_hotplug_thread - CPU hotplug related thread descriptor
-- 
1.7.4.4

