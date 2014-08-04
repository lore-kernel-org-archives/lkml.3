Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaHDRCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:02:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56557 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        "Fengguang Wu" <fengguang.wu@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.374235193@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 74/94] unicore32: select generic atomic64_t support
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Fengguang Wu <fengguang.wu@intel.com>

commit 82e54a6aaf8aec971fb16afa3a4404e238a1b98b upstream.

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/unicore32/Kconfig | 1 +
 1 file changed, 1 insertion(+)

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

