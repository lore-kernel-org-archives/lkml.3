Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbaGPPvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:51:55 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:46124 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823AbaGPPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:51:50 -0400
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <ralf@linux-mips.org>, <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <m.szyprowski@samsung.com>, <mina86@mina86.com>
CC: <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-arch@vger.kernel.org>
Subject: [PATCH 1/4] asm-generic: Add dma-contiguous.h
Date: Wed, 16 Jul 2014 16:51:29 +0100
Message-ID: <1405525892-60383-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header is used by arm64 and x86 individually.

Adding to asm-generic to avoid further code repetition while adding cma
to mips.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 include/asm-generic/dma-contiguous.h | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 include/asm-generic/dma-contiguous.h

diff --git a/include/asm-generic/dma-contiguous.h b/include/asm-generic/dma-contiguous.h
new file mode 100644
index 0000000..292c571
--- /dev/null
+++ b/include/asm-generic/dma-contiguous.h
@@ -0,0 +1,9 @@
+#ifndef _ASM_GENERIC_DMA_CONTIGUOUS_H
+#define _ASM_GENERIC_DMA_CONTIGUOUS_H
+
+#include <linux/types.h>
+
+static inline void
+dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
+
+#endif
-- 
1.9.1

