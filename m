Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaIOWKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:10:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbaIOWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/187] sparc64: Fix hex values in comment above pte_modify().
Date: Mon, 15 Sep 2014 15:07:08 -0700
Message-Id: <1410818997-9432-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit c2e4e676adb40ea764af79d3e08be954e14a0f4c ]

When _PAGE_SPECIAL and _PAGE_PMD_HUGE were added to the mask, the
comment was not updated.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 1f28103..50b2d78 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -258,8 +258,8 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t prot)
 {
 	unsigned long mask, tmp;
 
-	/* SUN4U: 0x600307ffffffecb8 (negated == 0x9ffcf80000001347)
-	 * SUN4V: 0x30ffffffffffee17 (negated == 0xcf000000000011e8)
+	/* SUN4U: 0x630107ffffffecb8 (negated == 0x9cfef80000001347)
+	 * SUN4V: 0x33ffffffffffee17 (negated == 0xcc000000000011e8)
 	 *
 	 * Even if we use negation tricks the result is still a 6
 	 * instruction sequence, so don't try to play fancy and just
-- 
1.9.1

