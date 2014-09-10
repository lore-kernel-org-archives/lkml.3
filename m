Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaIJKug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:50:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54300 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaIJKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:50:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cb-54102cf75abc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND] ARM: multi_v7_defconfig: Enable clock and RTC driver
 for S2M and S5M
Date: Wed, 10 Sep 2014 12:50:18 +0200
Message-id: <1410346218-31079-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Fd3vOgIhBv9OG1v8nXSM3WLjjPWs
	Fo1LLrNYvH5haHG26Q27xabH11gtLu+aw2Zx+zKvxdojd9kttm7ay2xx6vpnNosb01tYHXg8
	Wpp72Dx+/5rE6PFk00VGj4YD51k8Ni+p97hyoonVo7f5HZtH35ZVjB6fN8kFcEZx2aSk5mSW
	pRbp2yVwZaw4c4694CJ7xayTz1gbGC+ydTFyckgImEhcmnsZyhaTuHBvPZDNxSEksJRR4sHT
	mSwQTh+TxNy7bYwgVWwCxhKbly8BqxIR2Mgk8e5pNyuIwyxwlFFieu9bJpAqYYE4iZeXFjCD
	2CwCqhJv7v8B28Er4C5xpPMXI8Q+OYmTxyazTmDkXsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJPy+7GBcfMzqEKMAB6MSD2/hRf4QIdbEsuLK3EOMEhzMSiK8vzUEQoR4UxIrq1KL
	8uOLSnNSiw8xMnFwSjUwlrm7a50rrLrTsOo91/zcrvfh/PdfPI2qWycapJDeKv9cunf371Bu
	/U/74gT23ZeuW7SvJ0Iy/jJvKguL8+XzSnsCUrJlmL682TzP7strxaXnV/6fxiVXnJRbO2Wd
	+EP52Skf7BdenXn8E+tH1/mtvEdCOluEj11XO/i8X5Kdb3+vx1tn6b6ZSizFGYmGWsxFxYkA
	CfT8Eh0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config enables already Samsung's PMIC-s MFD and regulator drivers for
S2MPS11/S2MPS14 and S5M8767. Enable also drivers for the rest of these
PMIC-s features: clock and RTC.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5fb95fb758d9..7e25978f84f0 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -352,6 +352,7 @@ CONFIG_RTC_DRV_VT8500=y
 CONFIG_RTC_DRV_SUNXI=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_DMADEVICES=y
 CONFIG_DW_DMAC=y
 CONFIG_MV_XOR=y
@@ -373,6 +374,7 @@ CONFIG_SERIO_NVEC_PS2=y
 CONFIG_NVEC_POWER=y
 CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
-- 
1.9.1

