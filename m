Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaAGLvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:51:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40041 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaAGLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:30 -0500
X-AuditID: cbfee690-b7f266d00000287c-5b-52cbea406c5f
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com
Subject: [PATCH 0/5] crypto:s5p-sss: Add DT and Exynos5 support
Date: Tue, 07 Jan 2014 17:21:44 +0530
Message-id: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkStfh1ekgg5nT9S1eHtK06H4lY3H/
	3k8mi8u75rBZzDi/j8li0bb/zBZn5xxicmD32DnrLrvHtgOqHn1bVjF6fN4kF8ASxWWTkpqT
	WZZapG+XwJVx48Zn9oLpnBUbbwg1MDazdzFyckgImEgc/PqCFcIWk7hwbz1bFyMXh5DAUkaJ
	WxMfM8EUbVy5lhHEFhJYxCgx92kYRFE/k8SppsNg3WwC+hLLri8GKxIRcJb43bwGLM4s0Mwo
	8WM2mC0sYC/xccN8sBoWAVWJT1N/Ay3g4OAVcJX41hwMYkoIKEjMmWQDMl5C4DObxLv5+1kh
	ygUkvk0+xAJRIyux6QAzxGmSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7u
	JkZggJ7+92zCDsZ7B6wPMSYDjZvILCWanA8M8LySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJ
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPR/fnP1NduMHQc2WzF6vDh//M+HZc1tV3Zc1l/0
	V57t66M5m6uiZR6reV85VSg9ZwrfkjUsoXc2Hp+21uJgR/wR6+jiQ5r8/FtrtjWU/BUKnGm2
	4i7foo2vy52MRP+7zEnmOZ+y6PfyAJsg9ymTr1wrTdjwcMfzCW0/Vh2Prr/LZFF0cfGdZ0X8
	SizFGYmGWsxFxYkAP0lRXWYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAV2HV6eDDE43qVu8PKRp0f1KxuL+
	vZ9MFpd3zWGzmHF+H5PFom3/mS3OzjnE5MDusXPWXXaPbQdUPfq2rGL0+LxJLoAlqoHRJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdov5JCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx48aNz+wF0zkrNt4QamBsZu9i5OSQEDCR
	2LhyLSOELSZx4d56NhBbSGARo8Tcp2FdjFxAdj+TxKmmw6wgCTYBfYll1xeDNYgIOEv8bl4D
	FmcWaGaU+DEbzBYWsJf4uGE+WA2LgKrEp6m/mboYOTh4BVwlvjUHg5gSAgoScybZTGDkXsDI
	sIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOPyfSe1gXNlgcYhRgINRiYf3xd5TQUKsiWXF
	lbmHGCU4mJVEeJlvnA4S4k1JrKxKLcqPLyrNSS0+xJgMtHsis5Rocj4wNvNK4g2NTcxNjU0t
	TSxMzCxJE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbHg7+/fPIXyqettD8SkHWDydhGs
	qavc6n5gZlWmnFDy1Ezzt8lXDE+8KS1OMtK+vyFGcYpmm5rzgRAn5Q38d6+ZVC0y/fN3UcR7
	poTct4HbXjIVW1+eodFT5NtVEfJiVoxTLNPUhnqBmRmN73T+zyha/ejCQkXu1pCPrbd99ByW
	vl53tSRBVImlOCPRUIu5qDgRANlWLXvDAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSS module on Exynos5 SoCs has added features to the one on S5PV210
However minor changes to the s5p-sss.c driver are required to support
SSS modules on Exynos5 SoCs.

This patch set
1. Adds device tree support to the s5p-sss.c driver
2. Adds code to support SSS module on Exynos5 SoCs
3. Adds device tree node to Exynos5420
4. Also adds the DT binding documentation

Naveen Krishna Ch (4): [crypto-2.6.git]
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Add device tree and Exynos5 support
  crypto:s5p-sss: Add support for SSS module on Exynos5
  crypto:s5p-sss: Exynos5 SoCs too can select SSS driver

Naveen Krishna Chatradhi (1): [linuxsamsung.git]
  ARM: exynos5420: add dt node for sss module

 .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++
 arch/arm/boot/dts/exynos5420.dtsi                  |   10 ++
 drivers/crypto/Kconfig                             |    8 +-
 drivers/crypto/s5p-sss.c                           |  115 +++++++++++++++-----
 4 files changed, 127 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5

