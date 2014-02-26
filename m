Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaBZFIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:08:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56738 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBZFIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:08:10 -0500
X-AuditID: cbfee690-b7f266d00000287c-20-530d76b8b870
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/3] drivers: clk: add samsung common clock config option
Date: Wed, 26 Feb 2014 14:24:05 +0900
Message-id: <1393392247-6247-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t8zA90dZbzBBgveq1lsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2B1YPe5c28PmsXlJvUffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	HHmUXLCLp6L99HfGBsYVXF2MnBwSAiYS3RsamSFsMYkL99azdTFycQgJLGOUmN3wmQmm6MW/
	eWwgtpDAIkaJNb8iIYramCQW/jnMCpJgE9CVePJ+LtgkEYFsiUuzbrGA2MwCoRJP580EaxYW
	8JRYdH4DI4jNIqAqcWPjcbA4r4C7xL8Fy4F6OYCWKUjMmWQDEuYU8JB43DWHBWKvu8T14xuZ
	QfZKCPxnk7i06yQrxBwBiW+TD7FA9MpKbDoA9YykxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSi
	V5yYW1yal66XnJ+7iRESwhN2MN47YH2IMRlo3ERmKdHkfGAM5JXEGxqbGVmYmpgaG5lbmpEm
	rCTOq/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9FsU9250Q/F9rJ/el3999yF9r1r
	vh0KUlS8ZxrxQHcV814Bt52h579Jb9r4suf8rIiXlqwyF+O9/hQc4nyyim/9h98/9Nl8D/o+
	YFub5dKVW7L/7QnrDfwfWL9O/F17mM093MVfmSWhtr+q7pbeOxUj11X16+4VT/31yaGjzL9y
	+bLouvCS20osxRmJhlrMRcWJAMQOmOV3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jAd0dZbzBBreXK1tsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2B1YPe5c28PmsXlJvUffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZhx5lFywi6ei/fR3xgbGFVxdjJwcEgImEi/+zWODsMUk
	LtxbD2YLCSxilFjzK7KLkQvIbmOSWPjnMCtIgk1AV+LJ+7nMILaIQLbEpVm3WEBsZoFQiafz
	ZoI1Cwt4Siw6v4ERxGYRUJW4sfE4WJxXwF3i34LlQL0cQMsUJOZMsgEJcwp4SDzumsMCsddd
	4vrxjcwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOkGfSOxhXNVgcYhTgYFTi
	4Q1g4Q0WYk0sK67MPcQowcGsJMIrnQ0U4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5Hxg9OaV
	xBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6N4ZHzFyzfznwXr
	zHNYURm9QNbKVfnwXjM1Y/WqyuXCO6f7f/kpaPdr6tolXP25k5jqWnZ8vjT/LUultpKSu+K5
	8konffVwloPHL4WvF2VPn/NRK+9QflXey7wvkiz20320bGP4e5ftPn1Gc1ZP9k+nyWekfv++
	JaC3fLfDJL4PVRXNK6tzQpRYijMSDbWYi4oTAa9QAX7UAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add samsung common clock config option and let ARCH_EXYNOS or ARCH_S3CXXXX
select this if they want to use samsung common clock infrastructure.

CC: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Kconfig  |   10 ++++++++++
 drivers/clk/Makefile |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7641965..d93a325 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -23,6 +23,16 @@ config COMMON_CLK
 menu "Common Clock Framework"
 	depends on COMMON_CLK
 
+config COMMON_CLK_SAMSUNG
+	bool "Clock driver for Samsung SoCs"
+	depends on ARCH_S3C64XX || ARCH_S3C24XX || ARCH_EXYNOS || ARM64
+	---help---
+          Supports clocking on Exynos SoCs:
+	  - Exynos5250, Exynos5420 board.
+	  - Exynos4 boards.
+	  - S3C2412, S3C2416, S3C2466 boards.
+	  - S3C64XX boards.
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a98..f1da6ee 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_PLAT_ORION)		+= mvebu/
 obj-$(CONFIG_ARCH_MXS)			+= mxs/
 obj-$(CONFIG_COMMON_CLK_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
-obj-$(CONFIG_PLAT_SAMSUNG)		+= samsung/
+obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 obj-$(CONFIG_ARCH_SIRF)			+= sirf/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
-- 
1.7.9.5

