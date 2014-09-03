Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbaICLc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbaICLcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:32:54 -0400
From: Laszlo Ersek <lersek@redhat.com>
To: mingo@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com,
        lersek@redhat.com
Subject: [PATCH v2 1/5] efi: add macro for EFI_MEMORY_UCE memory attribute
Date: Wed,  3 Sep 2014 13:32:19 +0200
Message-Id: <1409743943-16934-2-git-send-email-lersek@redhat.com>
In-Reply-To: <1409743943-16934-1-git-send-email-lersek@redhat.com>
References: <1409743943-16934-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following macro from the UEFI spec, for completeness:

  EFI_MEMORY_UCE  Memory cacheability attribute: The memory region
                  supports being configured as not cacheable, exported,
                  and supports the "fetch and add" semaphore mechanism.

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45cb4ff..b4b1d8d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -92,6 +92,7 @@ typedef	struct {
 #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
 #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
 #define EFI_MEMORY_WB		((u64)0x0000000000000008ULL)	/* write-back */
+#define EFI_MEMORY_UCE		((u64)0x0000000000000010ULL)	/* uncached, exported */
 #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
 #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
 #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
-- 
1.8.3.1


