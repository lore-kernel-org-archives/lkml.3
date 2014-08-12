Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaHLRU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:20:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56987 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaHLRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:20:26 -0400
X-Auth-Info: U9Su56mIkKGnHk+IrkYaGeRLnXomMurkR25hGoCY/lQ=
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arm/xen: fix wrong conflict resolution of xen merge
CC: linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org
X-Yow: If this is the DATING GAME I want to know your FAVORITE PLANET!  Do I
 get th' MICROWAVE MOPED?
Date: Tue, 12 Aug 2014 19:20:22 +0200
Message-ID: <87fvh1vd49.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate definition of arch_gnttab_init.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/arm/xen/grant-table.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/xen/grant-table.c b/arch/arm/xen/grant-table.c
index 2c4041c..e437918 100644
--- a/arch/arm/xen/grant-table.c
+++ b/arch/arm/xen/grant-table.c
@@ -49,8 +49,3 @@ int arch_gnttab_init(unsigned long nr_shared)
 {
 	return 0;
 }
-
-int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status)
-{
-	return 0;
-}
-- 
2.0.4


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
