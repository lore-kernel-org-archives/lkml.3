Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaLBIx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:53:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaLBIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:08 -0500
X-AuditID: cbfee68d-f79296d000004278-05-547d7d37683a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/19] arm64: exynos5433: Enable ARMv8-based Exynos5433 SoC
 support
Date: Tue, 02 Dec 2014 17:49:50 +0900
Message-id: <1417510196-6714-14-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkRNe8tjbEYMMdHYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGW8XtzG
	WnCfvaJ1+Xq2BsZNbF2MnBwSAiYSc75PZIGwxSQu3FsPFOfiEBJYyijx8+UrJpiizecPghUJ
	CUxnlNiyXACiqIlJ4sGNDYwgCTYBLYn9L26ATRURcJZomNrIBFLELPCGWWLP/d1g3cICoRIT
	ZjSygtgsAqoSu1deAYvzCrhKnJn4CuoMBYlly2eC1XACxbvO9LFDbHaR+NX6kR1kqIRAL4fE
	ysYeFohBAhLfJh8CsjmAErISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL
	89L1kvNzNzEC4/H0v2e9OxhvH7A+xCjAwajEw3vyfE2IEGtiWXFl7iFGU6ANE5mlRJPzgVGf
	VxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD45LMc/Zf
	JSflti74uMEt2P2WmkLs8pOHjE6nxxl/ZWWX6Hw86aiB6o5980Kb/qZ32+pu/jzlX29ft8Q2
	zvJjHW1V6x9c2na/eb549W7vtVb63Q9DrJNMrL5VaAvM2RaiYGAzYcpanYW7p2y/oShrsNk8
	77i/tTFvcyjrjarEzcfqTkdNmnZdUYmlOCPRUIu5qDgRAPoCrVnCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg+WnlC0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx4/XiNtaC++wVrcvXszUwbmLrYuTkkBAwkdh8/iALhC0mceHe
	erC4kMB0RoktywW6GLmA7CYmiQc3NjCCJNgEtCT2v7gBViQi4CzRMLWRCaSIWeANs8Se+7vB
	JgkLhEpMmNHICmKzCKhK7F55BSzOK+AqcWbiK6htChLLls8Eq+EEined6WOH2Owi8av1I/sE
	Rt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj/ZnUDsaVDRaHGAU4GJV4eE+crwkR
	Yk0sK67MPcQowcGsJML7y7g2RIg3JbGyKrUoP76oNCe1+BCjKdBVE5mlRJPzgYkoryTe0NjE
	zMjSyNzQwsjYXEmc98bN3BAhgfTEktTs1NSC1CKYPiYOTqkGRpPT0+VcJ2/7deWrE/vE6mgr
	5ngV15svG/vSmCbHpf/LdU4L/KrOxMDw27D5OYewrE34R8doxylieR1q7Ns2HD/V8WGSSGvO
	kq/xWtGFd7kXf1hYXDfx7HnZX8HZT1/cS1UMPFawmF8pke92TKINw+wj/Q4LWZgjfKWzX248
	FlSUctL696f5SizFGYmGWsxFxYkANIqcuAwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary Kconfig entries to enable
support for the ARMv8 based Exynos5433 SoC.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 arch/arm64/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fa708a0..3fa5d91 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -146,6 +146,16 @@ config ARCH_EXYNOS
 	help
 	  This enables support for Samsung Exynos SoC family
 
+config ARCH_EXYNOS5433
+	bool "ARMv8 based Samsung Exynos5433"
+	select ARCH_EXYNOS
+	select COMMON_CLK_SAMSUNG
+	select PINCTRL
+	select PINCTRL_EXYNOS
+
+	help
+	  This enables support for Samsung Exynos5433 SoC family
+
 config ARCH_EXYNOS7
 	bool "ARMv8 based Samsung Exynos7"
 	select ARCH_EXYNOS
-- 
1.8.5.5

