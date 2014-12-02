Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaLBPl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:41:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20035 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:41:53 -0500
X-AuditID: cbfee61a-f79c06d000004e71-fc-547dddbea394
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: add MAINTAINERS entry for ARM Exynos cpuidle driver
Date: Tue, 02 Dec 2014 16:41:35 +0100
Message-id: <1616359.KRpRrFqxfV@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAd39d2tDDE79Z7aY91nWonfBVTaL
	/sevmS3ONr1ht9j0+BqrxeVdc9gsPvceYbSYcX4fkwOHx6ZVnWwed67tYfPYvKTeo2/LKkaP
	z5vkAlijuGxSUnMyy1KL9O0SuDJuvd3CWtDEVbH++22WBsbTHF2MnBwSAiYSO3t7mSBsMYkL
	99azdTFycQgJLGKU+DL7PAtIQkighUni4t4iEJtNwEpiYvsqRhBbREBPovF9GxNIA7PAd0aJ
	ndeusIEkhAV8JbZfXgrWzCKgKjFz5S0wm1dAU+L5yclgNaICnhI7px9ghIgLSvyYfA+shllA
	XmLf/qmsELaWxPqdx5kmMPLNQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIEB+8zqR2MKxssDjEKcDAq8fCeOF8TIsSaWFZcmXuIUYKDWUmE95dxbYgQb0piZVVqUX58
	UWlOavEhRmkOFiVx3hs3c0OEBNITS1KzU1MLUotgskwcnFINjLOXafCJVmct/dGU4TyBVWPa
	mTsH6oXanpqfEjM+/+/Gho44hYd86pP1jvv94WuZFZCm8Ppck81Obp0vGhzFZvsOiz+0ZF63
	Y45kXfSvie9MP06TPXXLofZu7dzADbFym1Yp8XIazl/QdsqkLG33WT7piKfCLH/jjwkn7P9U
	8/1l9BaP1J2WwUosxRmJhlrMRcWJAGNcY/ZaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there has been quite a lot of development going on for
ARM Exynos cpuidle driver recently I would like to add separate
MAINTAINERS entry for it and add myself as the primary maintainer.

The merging process would remain (almost) unchanged with patches
going (with my Ack) through Daniel's or Kukjin's tree.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS	2014-11-27 18:02:51.988225868 +0100
+++ b/MAINTAINERS	2014-12-02 15:56:52.792997513 +0100
@@ -2701,6 +2701,16 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/cpuidle/cpuidle-big_little.c
 
+CPUIDLE DRIVER - ARM EXYNOS
+M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+M:	Kukjin Kim <kgene@kernel.org>
+L:	linux-pm@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org
+S:	Supported
+F:	drivers/cpuidle/cpuidle-exynos.c
+F:	arch/arm/mach-exynos/pm.c
+
 CPUIDLE DRIVERS
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>

