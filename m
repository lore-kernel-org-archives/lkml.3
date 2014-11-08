Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaKHDKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 22:10:12 -0500
Received: from m131-177.yeah.net ([123.58.177.131]:52361 "EHLO
	m131-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaKHDKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 22:10:10 -0500
Message-ID: <545D8968.4080004@yeah.net>
Date: Sat, 08 Nov 2014 11:09:28 +0800
From: john_gong <john_gong@yeah.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: pbonzini@redhat.com,
        "Gleb Natapov <gleb@kernel.org> Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <"x86"@kernel.org>,
        "open list:KERNEL VIRTUAL MA..." <"kvm"@vger.kernel.org>,
        "open list:X86 ARCHITECTURE..." <"linux-kernel"@vger.kernel.org>
Subject: typo of the comment
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: ClUQrEApzkBoiV1Up8wdCA--.25302S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4fGrWfKFy5WFyUtFy5urg_yoWfAwb_Ca
	17Zw4UWw1FyF40van5CFW5ZF1fCw47ur1rAr1fJw1av3Zrta1UJFZ5Kry7Jr1agay7WrWI
	v3s8GrWxAw45AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0I1v3UUUUU==
X-Originating-IP: [222.65.57.26]
X-CM-SenderInfo: xmrk0spjrqwqh1hdxhhqhw/1tbiDQg+KVH7ZC83+gAAs+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Paolo,
i find a typo of the comment.


 From 09d5df31f0930e8e3eb10ad60a3debc53d6ce992 Mon Sep 17 00:00:00 2001
From: john_gong <john_gong@yeah.net>
Date: Fri, 7 Nov 2014 07:32:17 +0800
Subject: [PATCH] modify a typo of the comment

Signed-off-by: john_gong <john_gong@yeah.net>
---
  arch/x86/kvm/x86.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef432f8..42bb2c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -214,7 +214,7 @@ void kvm_define_shared_msr(unsigned slot, u32 msr)
      if (slot >= shared_msrs_global.nr)
          shared_msrs_global.nr = slot + 1;
      shared_msrs_global.msrs[slot] = msr;
-    /* we need ensured the shared_msr_global have been updated */
+    /* we need ensured the shared_msrs_global have been updated */
      smp_wmb();
  }
  EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
-- 
2.1.0


