Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaFYMux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:50:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44968 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaFYMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:50:50 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-c2-53aac5979e03
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 6/6] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
Date: Wed, 25 Jun 2014 18:15:42 +0530
Message-id: <1403700342-9678-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSrTv96Kpgg9YuK4tlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1jcfLadyYHbo6W5h81j
	85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqYfWsdc8FRlooH778yNzA+Z+5i5OSQEDCR
	OLnjPhuELSZx4d56IJuLQ0hgKaPE8tk3mWCK2rf2sEIkpjNK7FnxBqxDSGACk8S7K84gNpuA
	rsST93PBpooIZEv0317NAtLALHCKUWL25mnsIAlhAReJ5s4+FhCbRUBV4sWdPrA4r4C7xO0J
	h4BsDqBtChJzJtmAhDkFPCQeLbrBArHLXaKj4S87yEwJgXXsEn+Of2OGmCMg8W3yIRaIXlmJ
	TQegPpOUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQIj4PS/Z307GG8e
	sD7EmAw0biKzlGhyPjCC8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QD48Sd+QeaWfUVH+6Vb5VT8PX6mX+h4cX1Bx/Obb+zjO2G/1yrCa/bDV6+
	Lpb2+/JIYtU7TzGnSbXVM04tKjwdJSm7ekIXx5rAuGvvt3WelRQ2SJQsWeMt++eqpF3Ig9Vh
	tQIrw/bVtZ8VrZhk9rJd99GHe/26WQ0qN+ymXxNZGSgzk3evRA5bnBJLcUaioRZzUXEiANwl
	Ru+WAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd3pR1cFG6w/ZmKxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpUsX7GaxaLm8+2Mzlwe7Q097B5
	bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlARykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM2bf
	WsdccJSl4sH7r8wNjM+Zuxg5OSQETCTat/awQthiEhfurWfrYuTiEBKYziixZ8UbNpCEkMAE
	Jol3V5xBbDYBXYkn7+eCNYsIZEv0317NAtLALHCKUWL25mnsIAlhAReJ5s4+FhCbRUBV4sWd
	PrA4r4C7xO0Jh4BsDqBtChJzJtmAhDkFPCQeLbrBArHLXaKj4S/7BEbeBYwMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGC4+uZ9A7GVQ0WhxgFOBiVeHgvzF4ZLMSaWFZcmXuIUYKDWUmE
	133/qmAh3pTEyqrUovz4otKc1OJDjKZAR01klhJNzgfGfl5JvKGxibmpsamliYWJmaWSOO/B
	VutAIYH0xJLU7NTUgtQimD4mDk6pBsaECC5zD0cPP7X29muCmWLWy4r8j8yQ5d247qXK0qbX
	H7xyfhy/lRFs/aYhZzaPxP7AbVe18qcdbbsyuVpxue60dX0JpRt/xzotv3Mn4Ns7Sy9b9mmp
	xzly3r/+uZN9mrxlpJ5cOnNU8gOfZ83ec6wnplWU31XhZmaKsP+8N+tPpr7LK/dXBUosxRmJ
	hlrMRcWJAJP1m5zFAgAA
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

