Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaCMJhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:37:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38555 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaCMJhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:37:35 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-89-53217c5cc127
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/3] mfd: sec-core: Add of_compatible strings for MFD cells
Date: Thu, 13 Mar 2014 10:37:03 +0100
Message-id: <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xK7oxNYrBBhMO8lpsnLGe1eL1C0OL
	s01v2C3ufz3KaLHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xkszj5p5fR4nQ3q8XFFV+YLNbP
	eM1i0f53L5vFnOnvmBz4Pe5c28PmMe9koMfmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fA
	lXF3lVTBQa6KtwfWMTcwruLoYuTkkBAwkdiw/AoThC0mceHeerYuRi4OIYGljBIfj72HcvqY
	JJoed7KDVLEJGEtsXr4ELCEi0Mwkse/rYyYQh1ngLZPEnUM3gao4OIQF/CQWL0oBaWARUJXY
	/fQRC4jNK+Amsa3vJgtIiYSAgsScSTYgJqeAu0T/pCCQCiGgiit7e1knMPIuYGRYxSiaWppc
	UJyUnmuoV5yYW1yal66XnJ+7iRESml92MC4+ZnWIUYCDUYmHd8VyhWAh1sSy4srcQ4wSHMxK
	IrzmBYrBQrwpiZVVqUX58UWlOanFhxiZODilGhjNNA+cW/DtqaFYfVmD+3PJLJuNPi+4Cna0
	yNluPlOz3U7wfIOge+Lftr8yKdnpL4S4wg/H/b16fPPsl7OT9NRWeGT8yu0QOZWyVHvtzM1S
	Ubx8N4zf7NzG8W+abLM3Y9J74+PH6x3v+XZMNql+NvfImamRRXM2f9jPpH/3VtErizUs12RD
	TKWUWIozEg21mIuKEwF6hk+9KwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_compatible strings for MFD cells for regulator, clock and RTC
drivers in S5M8767, S2MPS11 and S2MPS14 PMIC-s.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index d163c66edebb..c5b9b95b2099 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -55,28 +55,36 @@ static const struct mfd_cell s5m8763_devs[] = {
 static const struct mfd_cell s5m8767_devs[] = {
 	{
 		.name = "s5m8767-pmic",
+		.of_compatible = "samsung,s5m8767-regulators",
 	}, {
 		.name = "s5m-rtc",
+		.of_compatible = "samsung,s5m8767-rtc",
 	}, {
 		.name = "s5m8767-clk",
+		.of_compatible = "samsung,s5m8767-clk",
 	}
 };
 
 static const struct mfd_cell s2mps11_devs[] = {
 	{
 		.name = "s2mps11-pmic",
+		.of_compatible = "samsung,s2mps11-regulators",
 	}, {
 		.name = "s2mps11-clk",
+		.of_compatible = "samsung,s2mps11-clk",
 	}
 };
 
 static const struct mfd_cell s2mps14_devs[] = {
 	{
 		.name = "s2mps14-pmic",
+		.of_compatible = "samsung,s2mps14-regulators",
 	}, {
 		.name = "s2mps14-rtc",
+		.of_compatible = "samsung,s2mps14-rtc",
 	}, {
 		.name = "s2mps14-clk",
+		.of_compatible = "samsung,s2mps14-clk",
 	}
 };
 
-- 
1.7.9.5

