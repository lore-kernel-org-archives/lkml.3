Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaEJHCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:02:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16497 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaEJHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:02:08 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-76-536dceefb286
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 4/6] ARM:  EXYNOS: Remove unused header inclusion from
 hotplug.c
Date: Sat, 10 May 2014 16:20:17 +0900
Message-id: <1399706419-13976-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t8zY93353KDDT5dNbD4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCwWbf3CbrF+xmsWB3aP378mMXpsXlLv0bdlFaPH501yASxRXDYp
	qTmZZalF+nYJXBkbVm1gLtjPUjF9w0P2BsYHzF2MnBwSAiYSJ64/hLLFJC7cW8/WxcjFISSw
	jFHi6eRWVpiiD4s2sUIkFjFKtD2bxALhtDFJNN++zwJSxSagK/Hk/VywUSIC2RJXGu+D2cwC
	6RIP3k4AmyQsECqxdFY/WD2LgKrE1c1zmEBsXgEPifsvPwDVcwBtU5CYM8kGJMwp4Cmx40cX
	G4gtJFAjsbzhBSPEQZPZJeb/zIEYIyDxbfIhFohWWYlNB6CekZQ4uOIGywRG4QWMDKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxQgJ74g7G+wesDzEmA42byCwlmpwPjIy8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDMLDp1ZNdLtXO2wf/n
	fmQQLmT5+ZxdZYeGt0XhWmY5r8dvdj+6b9l7hu+BwdYX2nVP5PJnXPl6qbDm+4WnhkI/N218
	sZiR8ez8m9KCszefP6jBuX+fR1KU+oONptNmcs+Qq7+61+rw136jXA+529MuFm64JvmXYXKH
	0pGahF8MCyUv5X39K+C+TYmlOCPRUIu5qDgRAL4E3TCCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jAd3353KDDZradS3+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+JotFW7+wW6yf8ZrFgd3j969JjB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMDas2MBfsZ6mYvuEhewPjA+YuRk4O
	CQETiQ+LNrFC2GISF+6tZ+ti5OIQEljEKNH2bBILhNPGJNF8+z4LSBWbgK7Ek/dzwbpFBLIl
	rjTeB7OZBdIlHrydADZJWCBUYumsfrB6FgFViaub5zCB2LwCHhL3X34AqucA2qYgMWeSDUiY
	U8BTYsePLjYQW0igRmJ5wwvGCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER84z
	qR2MKxssDjEKcDAq8fAWvM0JFmJNLCuuzD3EKMHBrCTCu+JgbrAQb0piZVVqUX58UWlOavEh
	xmSgoyYyS4km5wOjOq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGAMeGvQEaKf6xH++PI1HUaSe98L5vXLJv95ptHxeu4hVLMu/9GXqmcrcVTnHNFfxxMY+
	LO90+Lej0Nz9w61HtxP9umdbL/L5Pn/mbJf3ubLVBesuLp23olR8SdmxW9kC/sldqV8Mfsz/
	GvL4j3lx5ZNnup5q7SKm63e4mC4QMqizu6f4JnqbjhJLcUaioRZzUXEiAChbIHHgAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

