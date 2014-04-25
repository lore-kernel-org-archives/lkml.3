Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaDYMPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaDYMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:05 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-8e-535a51c7675d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 04/10] ARM: EXYNOS: Remove file path from comment section
Date: Fri, 25 Apr 2014 21:32:40 +0900
Message-id: <1398429166-5539-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+Zse7xwKhgg509ZhYbZ6xntVg26S6b
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8XhN+2sFutnvGaxuPlsO5PFjpbVLA48
	Hi3NPWwem5fUe/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAldG08sdzAU7+SumvpzB3MD4kaeL
	kZNDQsBE4tzko+wQtpjEhXvr2boYuTiEBJYxSrQu/MYEU3Rw7hVGiMQiRon5PxYzQThtTBKN
	1y6zgVSxCehKPHk/lxnEFhHIlrjSeB/MZhZ4zyjx+bA6iC0s4CNxtmkXC4jNIqAqcXLZD7DV
	vALuEv2dO4DiHEDbFCTmTLIBCXMKeEicWP6RHWJXK6PE+d+3WUAcCYF97BJnb/azQQwSkPg2
	+RBUs6zEpgPMEFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxgh0TBx
	B+P9A9aHGJOBxk1klhJNzgdGU15JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MFpyCOvIZsZMzfi8ns3s4eqL0tNdZxxvMVqzIOjduvZ7nIvvrl3x
	K+g4a9vPu2/Sz/yXOfG3Q1D8j9uaEw+yDA5/M5L45Z4tOnGB9T+u/9krMpWs8v+VWjlqcc87
	/1Zf4/BCOb49F8S1Dv4I92664mqqr7tg1jW770ePb680lBUT/da5SPzWuQIlluKMREMt5qLi
	RAA19KPinAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jAd3jgVHBBs/eG1hsnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BaH37SzWqyf8ZrF4uaz7UwWO1pWszjw
	eLQ097B5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYM5pe7mAu2MlfMfXlDOYGxo88XYycHBICJhIH515hhLDFJC7cW8/WxcjFISSwiFFi/o/F
	TBBOG5NE47XLbCBVbAK6Ek/ez2UGsUUEsiWuNN4Hs5kF3jNKfD6sDmILC/hInG3axQJiswio
	Spxc9oMdxOYVcJfo79wBFOcA2qYgMWeSDUiYU8BD4sTyj+wQu1oZJc7/vs0ygZF3ASPDKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYzgWHsmtYNxZYPFIUYBDkYlHt4PapHBQqyJZcWVuYcY
	JTiYlUR4P/hFBQvxpiRWVqUW5ccXleakFh9iTAa6aiKzlGhyPjAN5JXEGxqbmBlZGplZGJmY
	m5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD49EAn/5PyvL7wqyrph9hjj5zyLm68nhe
	4OObK3hsyvyZTHSKfT7bNh/beHva9veTdOInxi8TUDxy9OQP9d4s872afI+OphYIJ3wT26gl
	vNdBUebhhGSrHONrFbNPvzi4N3bbrPsVfd9WnJB2yTvw4Gehfa/ckvQHM7WnLnjx2eX8wrqv
	4pc+uSixFGckGmoxFxUnAgC8PFXU+QIAAA==
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

