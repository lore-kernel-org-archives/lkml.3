Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaEJHAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:00:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:59:57 -0400
X-AuditID: cbfee61b-b7f766d00000646c-f7-536dce6a6797
From: y@samsung.com
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 4/6] ARM:  EXYNOS: Remove unused header inclusion from
 hotplug.c
Date: Sat, 10 May 2014 16:18:05 +0900
Message-id: <1399706287-13919-5-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706287-13919-1-git-send-email-y@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xgG7Wudxggz/rFC3+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+JotFW7+wW6yf8ZrFgd3j969JjB6bl9R79G1ZxejxeZNcAEsUl01K
	ak5mWWqRvl0CV8bX3zNYCz6wVLz9bNfA2MXSxcjBISFgInH7j3IXIyeQKSZx4d56ti5GLg4h
	gUWMEieWzGGFcNqYJM4ufcUO0sAmICwx9YAWSIOIQLbElcb7zCA2s0C6xIO3E1hBbGGBUIml
	s/pZQGwWAVWJuwf2sIHYvAK2Ehfvz2OF2KsgMWeSDUiYU8BO4tq2ZrByIaCSKUcPM05g5F3A
	yLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziEnknvYFzVYHGIUYCDUYmHt/BtTrAQa2JZ
	cWXuIUYJDmYlEd4VB3ODhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgt
	gskycXBKNTBy5vdN06nOPKjPFOvfL/aaofahZWBkl3S+7EzFC/29fzw1XMNvLsnyMbv08eq3
	PdaMigc4e6/m89wSq3dcxXXv/zyZJoZ1vCdZv7ucW7bFWc7Q+dWNpLmdKWvfcnH1tR3Nnr85
	UF3Klf0gv/PqwOy5a+tnL5jx/8RJxd22uvLqemmRCac6NJRYijMSDbWYi4oTAYRaEysdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

This patch removed "plat/cpu.h" inclusion from hotplug.c as it
is not required.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 0243ef3..5e19601 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -19,8 +19,6 @@
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
 
-#include <plat/cpu.h>
-
 #include "common.h"
 #include "regs-pmu.h"
 
-- 
1.7.10.4

