Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaHHV7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:59:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaHHVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 22/39] sparc64: Fix hex values in comment above pte_modify().
Date: Fri,  8 Aug 2014 14:35:08 -0700
Message-Id: <20140808213355.936020068@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit c2e4e676adb40ea764af79d3e08be954e14a0f4c ]

When _PAGE_SPECIAL and _PAGE_PMD_HUGE were added to the mask, the
comment was not updated.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -258,8 +258,8 @@ static inline pte_t pte_modify(pte_t pte
 {
 	unsigned long mask, tmp;
 
-	/* SUN4U: 0x600307ffffffecb8 (negated == 0x9ffcf80000001347)
-	 * SUN4V: 0x30ffffffffffee17 (negated == 0xcf000000000011e8)
+	/* SUN4U: 0x630107ffffffecb8 (negated == 0x9cfef80000001347)
+	 * SUN4V: 0x33ffffffffffee17 (negated == 0xcc000000000011e8)
 	 *
 	 * Even if we use negation tricks the result is still a 6
 	 * instruction sequence, so don't try to play fancy and just


