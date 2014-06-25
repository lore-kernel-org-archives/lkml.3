Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaFYMtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:49:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47794 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaFYMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:49:44 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ea-53aac566c967
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 4/6] ARM: EXYNOS: Remove file path from comment section
Date: Wed, 25 Jun 2014 18:15:40 +0530
Message-id: <1403700342-9678-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSq5t2dFWwwdx1KhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx5th65oJm4YoZbWuYGxgbBboYOTkkBEwk
	3u/qY4awxSQu3FvP1sXIxSEksJRR4szRB6wwRVOvX2CESEwHSjx6xg7hTGCS+LLsMRNIFZuA
	rsST93PBRokIZEv0317NAlLELHCKUWL25mnsIAlhAS+JGa++MYLYLAKqEhOeNIOt4BVwl9h3
	ajvQIA6gdQoScybZgIQ5BTwkHi26wQJiCwGVdDT8ZYe4aBu7RNuJbIgxAhLfJh9igWiVldh0
	AOobSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMAJO/3vWu4Px9gHr
	Q4zJQOMmMkuJJucDIyivJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhg3yTrWe+htbtySqKfRcS711OsPEmu2TVFcGmma5bvw+IMF+pPnuW2Seacq
	+u7dx1vzrxWm2hUauqSLaiVrzrr2w0jd+NismwcizrmWRDaG7fER/ObN8IaVx1RTKP5AuVTQ
	M5mA12sN9RcdbXMz5PE7KCnEH3Jz1YSmK+c7pl2QLWDgNLHksFJiKc5INNRiLipOBABhbEwW
	lgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd20o6uCDaYsl7VYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGW+O
	rWcuaBaumNG2hrmBsVGgi5GTQ0LARGLq9QuMELaYxIV769m6GLk4hASmM0qcefSMHcKZwCTx
	ZdljJpAqNgFdiSfv5zKD2CIC2RL9t1ezgBQxC5xilJi9eRo7SEJYwEtixqtvYGNZBFQlJjxp
	ZgWxeQXcJfad2g40iANonYLEnEk2IGFOAQ+JR4tusIDYQkAlHQ1/2Scw8i5gZFjFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJERxhz6R2MK5ssDjEKMDBqMTDe2H2ymAh1sSy4srcQ4wSHMxK
	Irzu+1cFC/GmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MPrzSuINjU3MTY1NLU0sTMwslcR5
	D7RaBwoJpCeWpGanphakFsH0MXFwSjUwTp8pweZ765jJsqjPtjuZNx1afkn3Q1iv+qP1sYG3
	zWo/yExX0D8o5/SW81GkwLllS1+sTmt5cm1BxGZ+R9ePDcIPb/KI1L57079VoiN+Y3BI75Il
	dqsZktZvfvvjSva9KfcvBe5b+HFZUtzJuIrbvx98bWY49WBn7ytFReNt+yMt5pptkHpeeV2J
	pTgj0VCLuag4EQCI2XsgxgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many files under "arm/mach-exynos" are having file path in file
comment section which is invalid now.
So for better code maintainability let's remove them.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/headsmp.S             |    1 -
 arch/arm/mach-exynos/hotplug.c             |    3 +--
 arch/arm/mach-exynos/include/mach/map.h    |    3 +--
 arch/arm/mach-exynos/include/mach/memory.h |    3 +--
 arch/arm/mach-exynos/platsmp.c             |    3 +--
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index cdd9d91..b54f970 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -1,5 +1,4 @@
 /*
- *  linux/arch/arm/mach-exynos4/headsmp.S
  *
  *  Cloned from linux/arch/arm/mach-realview/headsmp.S
  *
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 8a134d0..572f6b1 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -1,5 +1,4 @@
-/* linux arch/arm/mach-exynos4/hotplug.c
- *
+/*
  *  Cloned from linux/arch/arm/mach-realview/hotplug.c
  *
  *  Copyright (C) 2002 ARM Ltd.
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 548269a..963002f 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -1,5 +1,4 @@
-/* linux/arch/arm/mach-exynos/include/mach/map.h
- *
+/*
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
diff --git a/arch/arm/mach-exynos/include/mach/memory.h b/arch/arm/mach-exynos/include/mach/memory.h
index 2a4cdb7..e19df1f 100644
--- a/arch/arm/mach-exynos/include/mach/memory.h
+++ b/arch/arm/mach-exynos/include/mach/memory.h
@@ -1,5 +1,4 @@
-/* linux/arch/arm/mach-exynos4/include/mach/memory.h
- *
+/*
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index ec02422..f82fd8d 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -1,5 +1,4 @@
-/* linux/arch/arm/mach-exynos4/platsmp.c
- *
+ /*
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
-- 
1.7.9.5

