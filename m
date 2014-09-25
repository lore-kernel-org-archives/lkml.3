Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaIYCIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:08:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4024 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYCIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:08:24 -0400
From: Li Bin <huawei.libin@huawei.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Randy Dunlap <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>, <wangyijing@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH] kprobes: Update Documentation/kprobes.txt
Date: Thu, 25 Sep 2014 10:32:09 +0800
Message-ID: <1411612329-32741-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 125e564("Move Kconfig.instrumentation to arch/Kconfig and
init/Kconfig") had removed the "Instrumentation Support" menu,
and the configurations under this had be moved to "General setup".
Update Documentation/kprobes.txt to reflect this change.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 Documentation/kprobes.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 4bbeca8..ca4a927 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -304,8 +304,8 @@ architectures:
 3. Configuring Kprobes
 
 When configuring the kernel using make menuconfig/xconfig/oldconfig,
-ensure that CONFIG_KPROBES is set to "y".  Under "Instrumentation
-Support", look for "Kprobes".
+ensure that CONFIG_KPROBES is set to "y". Under "General setup", look
+for "Kprobes".
 
 So that you can load and unload Kprobes-based instrumentation modules,
 make sure "Loadable module support" (CONFIG_MODULES) and "Module
-- 
1.7.1

