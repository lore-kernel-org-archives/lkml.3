Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaJLEvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:51:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:18556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaJLEvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:51:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,703,1406617200"; 
   d="scan'208";a="604027249"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v9 02/12] x86, mpx: rename cfg_reg_u and status_reg
Date: Sun, 12 Oct 2014 12:41:45 +0800
Message-Id: <1413088915-13428-3-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel SDM extension, MPX configuration and status registers
should be BNDCFGU and BNDSTATUS. This patch renames cfg_reg_u and
status_reg to bndcfgu and bndstatus.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..020142f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -379,8 +379,8 @@ struct bndregs_struct {
 } __packed;
 
 struct bndcsr_struct {
-	u64 cfg_reg_u;
-	u64 status_reg;
+	u64 bndcfgu;
+	u64 bndstatus;
 } __packed;
 
 struct xsave_hdr_struct {
-- 
1.7.1

