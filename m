Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaGGDx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17537 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaGGDxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:42 -0400
X-AuditID: cbfee690-b7fb56d000003439-bb-53ba19c51264
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 4/6] ARM: EXYNOS: Remove file path from comment section
Date: Mon, 07 Jul 2014 09:20:54 +0530
Message-id: <1404705056-11965-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSrXtUclewwZe5/BbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxZWd+QbNwxeF5RxkbGBsFuhg5OSQETCRm
	vLzMBGGLSVy4t56ti5GLQ0hgKaPEmVcdrDBF+199ZoFITGeUaOu8AOVMYJKYtfYzO0gVm4Cu
	xJP3c5lBbBGBbIn+26vBipgFTjFKzN48DaxIWMBLYu+Kx2D7WARUJaatuAkU5+DgFfCQ6JuT
	DWJKCChIzJlkA1LBKeApseTDJLCRQkAVd88dYgQZKSGwjl3iYMcGFogxAhLfJh9igeiVldh0
	gBniaEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzD8T/97NmEH470D
	1ocYk4HGTWSWEk3OB8ZPXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwym43FErWeFkmVrPRXe6HiJlI/ozr3J/7LxkVmHseEHy9+vfUfwGVuz+u
	4M5Zp3AvN0pf9bet4uWyhOIZlvnzw+slqhgyNjV6zLm71eRhXsTdmjT2f+2Pd9+byh9+zSxw
	1afLb+L/a6ie/+a7U1y78o45c/KhP0IfSqqmeLPkNvx/F+AtmJmqxFKckWioxVxUnAgARvmx
	DpUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd2jkruCDV5e47RYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGV92
	5hc0C1ccnneUsYGxUaCLkZNDQsBEYv+rzywQtpjEhXvr2boYuTiEBKYzSrR1XmCBcCYwScxa
	+5kdpIpNQFfiyfu5zCC2iEC2RP/t1WBFzAKnGCVmb54GViQs4CWxd8VjJhCbRUBVYtqKm0Bx
	Dg5eAQ+JvjnZIKaEgILEnEk2IBWcAp4SSz5MAhspBFRx99whxgmMvAsYGVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBEfXM+kdjKsaLA4xCnAwKvHwHli1M1iINbGsuDL3EKMEB7OSCO8Z
	N6AQb0piZVVqUX58UWlOavEhRlOgmyYyS4km5wMjP68k3tDYxNzU2NTSxMLEzFJJnPdgq3Wg
	kEB6YklqdmpqQWoRTB8TB6dUA6PngfeXg5dOuFdqX+y5w75Rsjl34Y7VBuXpfnbK1QGVl/2i
	Pl12keI/33rg2uQj4Q8e5z6ftUhlTu7UBa13dBf/OTXT96WM2alGq8+bOrwaI1eud4z/wrHz
	fc2pH14iCiGXF8aY2twyWM4x5bKj54M/T5bOjX5sfs9IZ8csEdl3h2xUXzTdfnJPiaU4I9FQ
	i7moOBEAFtYH88QCAAA=
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
index 55ed2e6..cd25a9c 100644
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

