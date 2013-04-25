Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3DYICU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:02:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49460 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3DYICP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:02:15 -0400
X-AuditID: cbfee68d-b7f016d000007930-5e-5178e30563f7
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
In-reply-to: 
Subject: [PATCH 3.8-stable] ARM: 7690/1: mm: fix CONFIG_LPAE typos
Date: Thu, 25 Apr 2013 17:02:13 +0900
Message-id: <000001ce418b$320597d0$9610c770$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGAA1lnVSAAEGGUsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY13WxxWBBr+6TCyWNHNbXN41h83i
	9mVei0W3zjBbLNj4iNHi5ccTLA5sHmvmrWH0aGnuYfPo27KK0WPj9idMHp83yQWwRnHZpKTm
	ZJalFunbJXBl9ByYzlrQJVBxYm4zcwPjCt4uRg4OCQETiQ9rErsYOYFMMYkL99azdTFycQgJ
	LGOU+LfjMBNEwkRiyuzdrCC2kMAiRom/t5Ihiv4ySnza9AusiE1AV+LY+i1gRSIC3hKnpvxi
	BiliFuhllHj1to0dottOYs2/eWwgNqcAj8S6P53MILawgJPEnyP3wOIsAqoSz/+dABvKC1S/
	fs07VghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ3yjLvHory7EDRESj56vYocoEZHY9+Id
	I8g9EgL32CVud39ggtglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxY
	wMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkXnt3MN4+YH2IMRlo/URmKdHkfGC855XE
	GxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcXW1yp3r
	T7a4K+6+LzJ93/eeK8r/J3jtUxZv85bsq2P48WPViuJFme+DApIlObNYhbM1AlRNp7Vk/Vj+
	6LiVwHQHmwJOozvqcqf+P7xTdG/OLu4jW9z+st/rMny520hB7bXO2wNdkj9XX9jUWqXGN+9v
	pfvv+rMRMQbX5x37uknKwvNxiEscjxJLcUaioRZzUXEiANaKoD/tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV3WxxWBBpMP6lssaea2uLxrDpvF
	7cu8FotunWG2WLDxEaPFy48nWBzYPNbMW8Po0dLcw+bRt2UVo8fG7U+YPD5vkgtgjWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNFzYDprQZdAxYm5zcwNjCt4uxg5OSQE
	TCSmzN7NCmGLSVy4t54NxBYSWMQo8fdWchcjF5D9l1Hi06ZfTCAJNgFdiWPrt4A1iAh4S5ya
	8osZpIhZoJdR4tXbNnaIbjuJNf/mgU3iFOCRWPenkxnEFhZwkvhz5B5YnEVAVeL5vxNgQ3mB
	6teveccKYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW6A5HECXqks8+qsLcUOExKPnq9ghSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp4Nn
	UjsYVzZYHGIU4GBU4uEVeFUeKMSaWFZcmXuIUYKDWUmEt2VjRaAQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wNTVV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBx
	cEo1MPqtl0gy/RFp2Hpy2x/bihyZDoVQ0e6+tNX+Z9alyt0WUPBU+/5U412E7cKq/u9vaxR2
	Cwrx/Fyobl8oUeGxa6VuJI/WLHe/uIKfRz3SJrJfOltc+iJ6q8tJo7u9F7fP0ixwaCy7e1qp
	udr/WnGzy6t2c4lHIcKs3z/3qKz2aP3ZyPzzXqOrEktxRqKhFnNRcSIAoG7wbEsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Paul Bolle <pebolle@tiscali.nl>"

commit 4e1db26a0b42e2b6e27c05d68adcc01709c2eed2 upstream

CONFIG_LPAE doesn't exist: the correct option is CONFIG_ARM_LPAE, so fix
up the two typos under arch/arm/.

The fix to head.S is slightly scary, but this is just for setting up
an early io-mapping for the serial port when running on a big-endian,
LPAE system. Since these systems don't exist in the wild (at least, I
have no access to one outside of kvmtool, which doesn't provide a serial
port suitable for earlyprintk), then we can revisit the code later if it
causes any problems.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/kernel/head.S  |    2 +-
 arch/arm/kernel/setup.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index e0eb9a1..8bac553 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -267,7 +267,7 @@ __create_page_tables:
 	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]
 
-#if defined(CONFIG_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
+#if defined(CONFIG_ARM_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
 	sub	r4, r4, #4			@ Fixup page table pointer
 						@ for 64-bit descriptors
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..62ead98 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -524,7 +524,7 @@ int __init arm_add_memory(phys_addr_t start, phys_addr_t
size)
 	size -= start & ~PAGE_MASK;
 	bank->start = PAGE_ALIGN(start);
 
-#ifndef CONFIG_LPAE
+#ifndef CONFIG_ARM_LPAE
 	if (bank->start + size < bank->start) {
 		printk(KERN_CRIT "Truncating memory at 0x%08llx to fit in "
 			"32-bit physical address space\n", (long
long)start);
-- 
1.7.9.5

