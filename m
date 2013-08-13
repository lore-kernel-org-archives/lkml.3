Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3HMPIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:08:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:61673 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3HMPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:08:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Kosina <trivial@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH-trivial] NUMA: fix typos in Kconfig help text
Date: Tue, 13 Aug 2013 11:06:50 -0400
Message-ID: <1376406410-2055-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..e92d974 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -827,7 +827,7 @@ config NUMA_BALANCING_DEFAULT_ENABLED
 	default y
 	depends on NUMA_BALANCING
 	help
-	  If set, autonumic NUMA balancing will be enabled if running on a NUMA
+	  If set, automatic NUMA balancing will be enabled if running on a NUMA
 	  machine.
 
 config NUMA_BALANCING
@@ -838,7 +838,7 @@ config NUMA_BALANCING
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
 	  The mechanism is quite primitive and is based on migrating memory when
-	  it is references to the node the task is running on.
+	  it has references to the node the task is running on.
 
 	  This system will be inactive on UMA systems.
 
-- 
1.8.1.2

