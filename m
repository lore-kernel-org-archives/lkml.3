Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaK0Hfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29957 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaK0HfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-09-5476d438778d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/19] arm64: exynos5433: Enable ARMv8-based Exynos5433 SoC
 support
Date: Thu, 27 Nov 2014 16:35:12 +0900
Message-id: <1417073716-22997-16-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRNfiSlmIwd8GFYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtM+bOcyWLT
	42usFpd3zWGzmHF+H5PF0usXmSxOXf/MZnH4TTurxYzJL9ksjs1YwmixatcfRouXH0+wOIh5
	rJm3htHj969JjB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABHFJdNSmpOZllqkb5d
	AlfG5H/b2Qvus1dsmzOLuYFxE1sXIyeHhICJxLPVy6FsMYkL99YD2VwcQgJLGSXuNZ5h6mJk
	Byv6yAMRns4ocfDaHWYIp4lJ4suVLUwgzWwCWhL7X9wAGyQi4CzRMLWRCaSIWeAjs0TDtIus
	IAlhgVCJmYuPgxWxCKhK7Pu8B2gSBwevgJvEvgM2EEcoSCxbPhOsnBMovP/rQTBbSMBVYtG3
	K2AzJQTmckh83XqEFWKOgMS3yYdYQOZICMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihO
	Si8y0itOzC0uzUvXS87P3cQIjMrT/5717WC8ecD6EKMAB6MSD6/FgbIQIdbEsuLK3EOMpkAb
	JjJLiSbnA2M/ryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxlaBFWZCfne/9Yn4dD5e/O9x1UK/2571U5zOuU9bp8J+9ECJQ9hkN+E5wjmazd/1/51T
	9CwSjWbJmum3l03fZOXpk39KuOdfsgg+//QpayLndeWlGxN3Tfi90NDBiIfhwu3yL4+YrVyX
	ev0+wtx6rjmo4r95S2iA7U59t3uzZEM8tSfw7fr0VYmlOCPRUIu5qDgRAOBKXnXFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBjPmS1k8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZkz+t5294D57xbY5s5gbGDexdTGyc0gImEh85Oli
	5ASyxCQu3FsPFOXiEBKYzihx8NodZginiUniy5UtTCBVbAJaEvtf3GADsUUEnCUapjYygRQx
	C3xklmiYdpEVJCEsECoxc/FxsCIWAVWJfZ/3AE3i4OAVcJPYd8AGYpuCxLLlM8HKOYHC+78e
	BLOFBFwlFn27wjSBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCYfya9g3FVg8Uh
	RgEORiUeXosDZSFCrIllxZW5hxglOJiVRHilFgGFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0
	OR+YjvJK4g2NTcyMLI3MDS2MjM2VxHlv3MwNERJITyxJzU5NLUgtgulj4uCUamDM2lhdfvD1
	cs2Jkhdqco9JH36tzhnF2bJzqY+lbFBMy72Fk5f/Eztfv37xxq6FPUGvFih+9Pu04uPUO1u+
	Rc+afVS5S12F6Ul804qF193D9k44Wzkr5ZmV3uJZkZMMMo1mrfes+1TAyLvh+N5bBQKa19yY
	/lXxK2ye8jY5t+bxhh/b4hwsDFiOKrEUZyQaajEXFScCAAUo3XQPAwAA
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
index f4536e0..8a5e8a0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -152,6 +152,16 @@ config ARCH_EXYNOS
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

