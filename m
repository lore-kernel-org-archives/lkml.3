Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034AbaLLTNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:13:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:53374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934940AbaLLTMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="622909856"
Subject: [RFC][PATCH 4/8] x86, mpx: remove redundant MPX_BNDCFG_ADDR_MASK
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        qiaowei.ren@intel.com, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:18 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191218.B4B43847@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Qiaowei Ren <qiaowei.ren@intel.com>

MPX_BNDCFG_ADDR_MASK is defined two times, so this patch removes
redundant one.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/mpx.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/include/asm/mpx.h~0001-x86-mpx-remove-redundant-MPX_BNDCFG_ADDR_MASK arch/x86/include/asm/mpx.h
--- a/arch/x86/include/asm/mpx.h~0001-x86-mpx-remove-redundant-MPX_BNDCFG_ADDR_MASK	2014-12-12 11:11:40.228999056 -0800
+++ b/arch/x86/include/asm/mpx.h	2014-12-12 11:11:40.231999192 -0800
@@ -45,7 +45,6 @@
 #define MPX_BNDSTA_TAIL		2
 #define MPX_BNDCFG_TAIL		12
 #define MPX_BNDSTA_ADDR_MASK	(~((1UL<<MPX_BNDSTA_TAIL)-1))
-#define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
 #define MPX_BT_ADDR_MASK	(~((1UL<<MPX_BD_ENTRY_TAIL)-1))
 
 #define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
_
