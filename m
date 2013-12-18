Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3LRVjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:39:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3LRVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.12 001/118] arm64: mm: Fix PMD_SECT_PROT_NONE definition
Date: Wed, 18 Dec 2013 13:10:38 -0800
Message-Id: <20131218211219.506349458@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Capper <steve.capper@linaro.org>

commit db4ed53cfe9f5a00355891a631d47dfa3fd4541f upstream.

Modify the value of PMD_SECT_PROT_NONE to match that of PTE_NONE. This
should have been in commit 3676f9ef5481 (Move PTE_PROT_NONE higher up).

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable-hwdef.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -43,7 +43,7 @@
  * Section
  */
 #define PMD_SECT_VALID		(_AT(pmdval_t, 1) << 0)
-#define PMD_SECT_PROT_NONE	(_AT(pmdval_t, 1) << 2)
+#define PMD_SECT_PROT_NONE	(_AT(pmdval_t, 1) << 58)
 #define PMD_SECT_USER		(_AT(pmdval_t, 1) << 6)		/* AP[1] */
 #define PMD_SECT_RDONLY		(_AT(pmdval_t, 1) << 7)		/* AP[2] */
 #define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)


