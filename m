Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaIWCkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:38542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaIWCkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:45 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Jonas Bonn <jonas@southpole.se>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 37/45] openrisc: add missing header inclusion
Date: Tue, 23 Sep 2014 10:31:39 +0800
Message-Id: <1411439507-30391-37-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 160d83781a32e94a1e337efd6722939001e62398 upstream.

Prevents build issue with updated toolchain

Reported-by: Jack Thomasson <jkt@moonlitsw.com>
Tested-by: Christian Svensson <blue@cmd.nu>
Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/openrisc/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 1088b5f..2745196 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -19,6 +19,7 @@
 #include <linux/threads.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/serial_reg.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-- 
1.7.9.5

