Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBZFIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:08:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35779 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBZFIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:08:19 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-c7-530d76badd32
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/3] ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and
 ARCH_S3C64XX
Date: Wed, 26 Feb 2014 14:24:06 +0900
Message-id: <1393392247-6247-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t8zY91dZbzBBh13JC02Pb7GanF51xw2
	ixnn9zFZ3L7Ma7Fo6xd2B1aPluYeNo/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6Pp
	7h7mgnesFe/7PjA3MD5j6WLk5JAQMJGYsGwhM4QtJnHh3nq2LkYuDiGBZYwSC76/giv6tOQE
	K0RiEaPE/4t3WSCcNiaJ0zt3grWzCehKPHk/F8wWEciWuDTrFlg3s0CIxO0Xq8DiwgJhEn9e
	H2UCsVkEVCXOP93IBmLzCrhLXF86m72LkQNom4LEnEk2IGFOAQ+Jx11zwMYIgZQc38gMsldC
	4D+bxNTXj1gg5ghIfJt8iAWiV1Zi0wGobyQlDq64wTKBUXgBI8MqRtHUguSC4qT0IkO94sTc
	4tK8dL3k/NxNjJAg7t3BePuA9SHGZKBxE5mlRJPzgVGQVxJvaGxmZGFqYmpsZG5pRpqwkjhv
	0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MTh0iLsyfy9Yacs/Tyjy7+d9Snas6m9P/
	BmQe5Tpca16vuT7yX6oq9/7ydZNf97EtceVerHjv9q0tSkuOchzzKei+tOeT9sdbyVNzWs+U
	1QXVzYnd8W+OzYyb/MlrFY8ZlBq8qf6z6f7Bi26qN6qmx+UxhK28HNe2bs8vVvlnaTePfkqc
	LNvhrMRSnJFoqMVcVJwIAOY3msx4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jAd1dZbzBBl/fiVpsenyN1eLyrjls
	FjPO72OyuH2Z12LR1i/sDqweLc09bB6bl9R79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWNG0909zAXvWCve931gbmB8xtLFyMkhIWAi8WnJCVYIW0zi
	wr31bF2MXBxCAosYJf5fvMsC4bQxSZzeuZMZpIpNQFfiyfu5YLaIQLbEpVm3wCYxC4RI3H6x
	CiwuLBAm8ef1USYQm0VAVeL8041sIDavgLvE9aWz2bsYOYC2KUjMmWQDEuYU8JB43DUHbIwQ
	SMnxjcwTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOkWdSOxhXNlgcYhTgYFTi
	4Q1g4Q0WYk0sK67MPcQowcGsJMIrnQ0U4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5Hxg/OaV
	xBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6ND/KmU4gsPSvZY
	TjDQmufy8K+iCkevl3y1e/TTE5mn2K7Kbz9U/GSSoWbuppQFdgUprjLWj4N7gjSYXh/8VfbE
	zfPq/lWF9g8m+P89YmFhs5Ktsu79T/MPBjFmn3z7HZLi1c53bpZS7xLZsmbq2tZMkc3iK41c
	Vym4zNp5vM2/gG/1cq1j25VYijMSDbWYi4oTAfFzyEnVAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..cc8868d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -756,6 +756,7 @@ config ARCH_S3C64XX
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
 	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V6K
 	select GENERIC_CLOCKEVENTS
 	select GPIO_SAMSUNG
@@ -835,6 +836,7 @@ config ARCH_EXYNOS
 	select ARCH_SPARSEMEM_ENABLE
 	select ARM_GIC
 	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_S3C2410_I2C if I2C
-- 
1.7.9.5

