Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaGGDyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:54:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35216 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaGGDxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:45 -0400
X-AuditID: cbfee690-b7fb56d000003439-e8-53ba19c80df7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 6/6] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
Date: Mon, 07 Jul 2014 09:20:56 +0530
Message-id: <1404705056-11965-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpXtCclewQdduNYtlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1jcfLadyYHbo6W5h81j
	85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqYfWsdc8FRlooH778yNzA+Z+5i5OCQEDCR
	mHJZtYuRE8gUk7hwbz1bFyMXh5DAUkaJ5Z1T2SESJhL3dq+BSkxnlFj68z8jhDOBSaK1YyVY
	FZuArsST93OZQWwRgWyJ/turWUCKmAVOMUrM3jwNrEhYwEVi1vvzYDaLgKrEhnl72EDO4BXw
	kGhb5QxxkYLEnEk2IBWcAp4SSz5MAhspBFRx99whRoiDVrFLTOkwhpgiIPFt8iEWiFZZiU0H
	mCFKJCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MwOA//e/ZhB2M9w5Y
	H2JMBho3kVlKNDkfGD15JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cDodqH4dZT+sl1ujh8/aHFZWihZJZtybJz+xvvfxX+Lpqcv0Gu+r/Bg88be
	KuO98r5rRCV8dPTqjqU/fbE8c4rDx0uTpQtkuHdFyrOEst91btq72Pvca8vo/R/MXy+RL31a
	0ruibMK3h6o9N27v4v8kOLlkyUTT/y82LbOrrZa4wFrWfGi+XliWEktxRqKhFnNRcSIAieSF
	HpQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd0TkruCDZ5vkrNYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGbNv
	rWMuOMpS8eD9V+YGxufMXYycHBICJhL3dq9hg7DFJC7cWw9kc3EICUxnlFj68z8jhDOBSaK1
	YyU7SBWbgK7Ek/dzwbpFBLIl+m+vZgEpYhY4xSgxe/M0sCJhAReJWe/Pg9ksAqoSG+btARrL
	wcEr4CHRtsoZxJQQUJCYM8kGpIJTwFNiyYdJYCOFgCrunjvEOIGRdwEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4Ph6Jr2DcVWDxSFGAQ5GJR7eA6t2BguxJpYVV+YeYpTgYFYS4T3j
	BhTiTUmsrEotyo8vKs1JLT7EaAp000RmKdHkfGDs55XEGxqbmJsam1qaWJiYWSqJ8x5stQ4U
	EkhPLEnNTk0tSC2C6WPi4JRqYMzo9T7m/3Sxx4RNUq8Mig7e8bp2ZVoc1wRRHnMvB3e1hgKj
	v35nVv4qi6n89HWu3fUpbd8kn//ZGc7489JbI46qjOAjBXvDL2mI9Fps/2S8ed8yjm4W13SZ
	0Iw3/6qTE3rU05rV/Myb36jtvuUou4fT/vTSdbbLxBo2Zp5vbJ2k07jn47Y3WUosxRmJhlrM
	RcWJAE1x0NfFAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary header file inclusion from pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index fb0deda..dcfcb44 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -11,7 +11,6 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/bug.h>
 
 #include "common.h"
 #include "regs-pmu.h"
-- 
1.7.9.5

