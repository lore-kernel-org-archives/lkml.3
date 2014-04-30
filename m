Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaD3E7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:59:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38443 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaD3E7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:42 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-21-5360833d52ff
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 05/12] ARM: EXYNOS: Remove file path from comment section
Date: Wed, 30 Apr 2014 14:17:30 +0900
Message-id: <1398835057-3860-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zA13b5oRggwm7pC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZfyZcIW54AV/xY+b7cwNjLN5uxg5OSQETCTOXP3G
	DGGLSVy4t56ti5GLQ0hgGaPExIm9TDBFv9d8ZYFILGKU6L74hAUkISTQxiQxZZUCiM0moCvx
	5P1csEkiAtkSVxrvM4M0MAvsZpRobJzHBpIQFvCRWN70E2wqi4CqxK0Ft8FsXgF3ifuLLwHV
	cABtU5CYM8kGJMwp4CGx8PZvVohd7hINDT2MIDMlBNaxS6z+uQ1qjoDEt8mHWCB6ZSU2HYD6
	RlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECAn73h2Mtw9YH2JMBho3
	kVlKNDkfGDd5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cCY+3qBgqKV66wLHyJ2TJVfIrHvzsvtv6eukna79vjQc5ZPwl+PKK2QKfxzo/1Dq8O1
	H37uV02PB3PrK9j6Vu6NqT/ip/jEWnDe71cf/x3mORP3luGYN2PF/FPO9u2LV1tmFLxc9qXL
	RFLcutspYMLj/9xXcm6aMjOE3Ntz9MM6FTubJl7+haXVSizFGYmGWsxFxYkA5lc1QpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3b5oRgg3krxC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z4M+EKc8EL
	/oofN9uZGxhn83YxcnJICJhI/F7zlQXCFpO4cG89WxcjF4eQwCJGie6LT8ASQgJtTBJTVimA
	2GwCuhJP3s9lBrFFBLIlrjTeZwZpYBbYzSjR2DiPDSQhLOAjsbzpJxOIzSKgKnFrwW0wm1fA
	XeL+4ktANRxA2xQk5kyyAQlzCnhILLz9mxVil7tEQ0MP4wRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgqPqmdQOxpUNFocYBTgYlXh4BbbGBwuxJpYVV+YeYpTgYFYS4T1fmRAs
	xJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAiM8riTc0NjEzsjQyszAyMTcnTVhJnPdAq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBsbus5z+ZZem1iTkLDy16MnZ23l7Fh+T4tLn4814ea35aOrs
	FY7OsXqebnx5ny11DZdJyom/3b1nsva/6NIpSzRLHrRIH74Qct52ZlR8m9XrAzzxCg7hHItW
	LTuQI3RF3m36lhdFxkXhs+XKjNTNFxwTqtlQVWM7z3PD/NdcIq05xVIL1cquFyixFGckGmox
	FxUnAgCOmED67gIAAA==
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
 arch/arm/mach-exynos/headsmp.S             |    2 --
 arch/arm/mach-exynos/hotplug.c             |    3 +--
 arch/arm/mach-exynos/include/mach/memory.h |    3 +--
 arch/arm/mach-exynos/platsmp.c             |    3 +--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index cdd9d91..698c57f 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/arm/mach-exynos4/headsmp.S
- *
  *  Cloned from linux/arch/arm/mach-realview/headsmp.S
  *
  *  Copyright (c) 2003 ARM Limited
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..73b0b5c 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -1,5 +1,4 @@
-/* linux arch/arm/mach-exynos4/hotplug.c
- *
+/*
  *  Cloned from linux/arch/arm/mach-realview/hotplug.c
  *
  *  Copyright (C) 2002 ARM Ltd.
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
index 03e5e9f..29c2286 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -1,5 +1,4 @@
-/* linux/arch/arm/mach-exynos4/platsmp.c
- *
+/*
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
-- 
1.7.10.4

