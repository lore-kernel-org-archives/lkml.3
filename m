Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaKLRFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:05:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:39959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaKLRFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:05:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="635833402"
Subject: [PATCH 01/11] x86, mpx: rename cfg_reg_u and status_reg
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 12 Nov 2014 09:04:44 -0800
References: <20141112170443.B4BD0899@viggo.jf.intel.com>
In-Reply-To: <20141112170443.B4BD0899@viggo.jf.intel.com>
Message-Id: <20141112170444.C21FBF7E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>


According to Intel SDM extension, MPX configuration and status registers
should be BNDCFGU and BNDSTATUS. This patch renames cfg_reg_u and
status_reg to bndcfgu and bndstatus.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/processor.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/processor.h~2014-10-14-02_12-x86-mpx-rename-cfg-reg-u-and-status-reg arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h~2014-10-14-02_12-x86-mpx-rename-cfg-reg-u-and-status-reg	2014-11-12 08:49:23.517782202 -0800
+++ b/arch/x86/include/asm/processor.h	2014-11-12 08:49:23.521782383 -0800
@@ -380,8 +380,8 @@ struct bndreg {
 } __packed;
 
 struct bndcsr {
-	u64 cfg_reg_u;
-	u64 status_reg;
+	u64 bndcfgu;
+	u64 bndstatus;
 } __packed;
 
 struct xsave_hdr_struct {
_
