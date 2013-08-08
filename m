Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966709Ab3HHVIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:08:36 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:45325 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966684Ab3HHVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:08:32 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 4/4] asm-generic: Fix typo in comment after #endif
Date: Thu,  8 Aug 2013 21:07:02 +0000
Message-Id: <1375996022-8298-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the comment so that it matches the actual name of the include
guard used.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/asm-generic/bitops/arch_hweight.h |    2 +-
 include/asm-generic/bitops/atomic.h       |    2 +-
 include/asm-generic/pci_iomap.h           |    2 +-
 include/asm-generic/signal.h              |    2 +-
 include/asm-generic/vga.h                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 6a211f4..d6be0af 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -22,4 +22,4 @@ static inline unsigned long __arch_hweight64(__u64 w)
 {
 	return __sw_hweight64(w);
 }
-#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
+#endif /* _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 9ae6c34..d3ac7d5 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -186,4 +186,4 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return (old & mask) != 0;
 }
 
-#endif /* _ASM_GENERIC_BITOPS_ATOMIC_H */
+#endif /* _ASM_GENERIC_BITOPS_ATOMIC_H_ */
diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index ce37349..0b5f271 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -32,4 +32,4 @@ static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned lon
 }
 #endif
 
-#endif /* __ASM_GENERIC_IO_H */
+#endif /* __ASM_GENERIC_PCI_IOMAP_H */
diff --git a/include/asm-generic/signal.h b/include/asm-generic/signal.h
index d840c90..1fc827f 100644
--- a/include/asm-generic/signal.h
+++ b/include/asm-generic/signal.h
@@ -11,4 +11,4 @@
 #undef __HAVE_ARCH_SIG_BITOPS
 
 #endif /* __ASSEMBLY__ */
-#endif /* _ASM_GENERIC_SIGNAL_H */
+#endif /* __ASM_GENERIC_SIGNAL_H */
diff --git a/include/asm-generic/vga.h b/include/asm-generic/vga.h
index 36c8ff5..93b8a80 100644
--- a/include/asm-generic/vga.h
+++ b/include/asm-generic/vga.h
@@ -21,4 +21,4 @@
 #define vga_readb(x) (*(x))
 #define vga_writeb(x, y) (*(y) = (x))
 
-#endif /* _ASM_GENERIC_VGA_H */
+#endif /* __ASM_GENERIC_VGA_H */
-- 
1.7.9.5

