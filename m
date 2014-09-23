Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaIWClG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:41:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:38599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaIWCk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:56 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 40/45] unicore32: select generic atomic64_t support
Date: Tue, 23 Sep 2014 10:31:42 +0800
Message-Id: <1411439507-30391-40-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 82e54a6aaf8aec971fb16afa3a4404e238a1b98b upstream.

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/unicore32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..1f3e9ea 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -6,6 +6,7 @@ config UNICORE32
 	select HAVE_DMA_ATTRS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
+	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
 	select GENERIC_FIND_FIRST_BIT
-- 
1.7.9.5

