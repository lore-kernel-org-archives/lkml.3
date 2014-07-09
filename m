Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaGILk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:40:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaGILgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-83-53bd293e954e
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 07/21] x86: Kconfig: enable kernel address
 sanitizer
Date: Wed, 09 Jul 2014 15:30:01 +0400
Message-id: <1404905415-9046-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xy7p2mnuDDbYf5LfY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroyzKzsYCyaxVDxuu8rYwLiJ
	uYuRk0NCwERi1moYW0ziwr31bCC2kMBSRonFHwu7GLmA7D4mies3W8ASbAJ6Ev9mbQezRQQU
	JDb3PmMFKWIWaGaTaO/4AORwcAgLhEu0rXYHMVkEVCWOnlQDKecVcJXovniDHWKXgsSy5TNZ
	QWxOATeJCdOvMYOUCwHVTFihNoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkCj6
	uoNx6TGrQ4wCHIxKPLwvdu8JFmJNLCuuzD3EKMHBrCTCayu6N1iINyWxsiq1KD++qDQntfgQ
	IxMHp1QD422WeVVTeKb+fekgcrLgsdn3ug7uZR+ZTJ9eaJJhfnrpc3ry9anH2homfL69Zvak
	DXPkG73k8x1d/E33/MmSiHFneyC1WNj67JZXZsedpW9+maoYcLaQi58tynb3Ce+UcA/G16Vs
	lYyCcRMf+3mvn/3oYL8UK1d/7/H9U3iWc5c/ufI9PGNHohJLcUaioRZzUXEiAF1D4tCAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now everything in x86 code is ready for kasan. Enable it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8657c06..f9863b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,6 +132,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_KASAN
 
 config INSTRUCTION_DECODER
 	def_bool y
-- 
1.8.5.5

