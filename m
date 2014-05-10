Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaEJGit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaEJGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:43 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-8e-536dc961d80b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 04/11] ARM: EXYNOS: Remove file path from comment section
Date: Sat, 10 May 2014 15:56:31 +0900
Message-id: <1399704998-13321-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t8zI93Ek7nBBs/3KFosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyvj/8DJbwQv+ilMnihsYZ/N2MXJySAiYSHTfvsUK
	YYtJXLi3nq2LkYtDSGAZo8T5iyvYYIpa9sxihkhMZ5RYPeUeI4TTxiRxc+YxFpAqNgFdiSfv
	5zKD2CIC2RJXGu+DdTAL7GaUaGycBzZKWMBHYsecW0A2BweLgKrElikyICavgIfEkY1mIKaE
	gILEnEk2IMWcAp4SX78uZgKxhYAqHnQvBZsoIbCKXaL92y1GkASLgIDEt8mHWCB6ZSU2HWCG
	uFlS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAgJ+Qk7GO8dsD7EmAw0
	biKzlGhyPjBm8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBcV1nh9G04Po/91SXidgJhnBc974ZI5roy9b+6rA496d01ZLLnMwaS64lTHO2yNfw
	8XPd37384Ir7TGuWfPvOmFv6PzbjfYr25TdJT3sSK6fNvKO0LilZLUjxyM/pfE7/vq67sczv
	77O4a66XKjI8HjJaZ769e2Lz/vqisDTPFHdnUZ6IiQc8lViKMxINtZiLihMBtCEdaY8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd3Ek7nBBvMWy1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jx/+FltoIX
	/BWnThQ3MM7m7WLk5JAQMJFo2TOLGcIWk7hwbz1bFyMXh5DAdEaJ1VPuMUI4bUwSN2ceYwGp
	YhPQlXjyfi5Yh4hAtsSVxvvMIEXMArsZJRob57GBJIQFfCR2zLkFZHNwsAioSmyZIgNi8gp4
	SBzZaAZiSggoSMyZZANSzCngKfH162ImEFsIqOJB91LmCYy8CxgZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIER9QzqR2MKxssDjEKcDAq8fAWvM0JFmJNLCuuzD3EKMHBrCTCu+JgbrAQ
	b0piZVVqUX58UWlOavEhxmSgkyYyS4km5wOjPa8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKWA0f7vudSRqGerL2oyl0zfkym/vi/tmUNoWrGkGrvf+UKWGa4W
	O/6VSho9jOiXi2C40BtlZ3Dq1Of6Db7L3T5qhj131v0TPv3znc+fjfQCP5p+Up8t9l3JpLgm
	M3nR1sknynes3B0bGVZ/8rXsu+ykciG+O4c8F1xXuuI7cX8qp2zr8ynhJy7eVmIpzkg01GIu
	Kk4EAIJ4SRvsAgAA
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
index 3611241..1f63596 100644
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

