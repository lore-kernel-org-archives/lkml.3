Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab3FDG23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:28:29 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39672 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab3FDG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:28:27 -0400
Message-ID: <51AD8902.60603@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:28:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Shi <alex.shi@intel.com>,
        fenghua.yu@intel.com
Subject: [PATCH] code clean in __flush_tlb_one()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-2000-0000-0000-00000C5D9E09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the extra space in __flush_tlb_one()

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Alex Shi <alex.shi@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/x86/include/asm/tlbflush.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h
b/arch/x86/include/asm/tlbflush.h
index 50a7fc0..cf51200 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)

 static inline void __flush_tlb_one(unsigned long addr)
 {
-		__flush_tlb_single(addr);
+	__flush_tlb_single(addr);
 }

 #define TLB_FLUSH_ALL	-1UL
-- 
1.7.4.1

