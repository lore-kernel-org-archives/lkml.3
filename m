Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaCGKLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:11:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17166 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaCGKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:11:05 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4e-53199b37c171
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/3] regulator: s2mps11: Add support for S2MPS14 regulators
Date: Fri, 07 Mar 2014 11:10:49 +0100
Message-id: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xa7rmsyWDDXa2yFpsnLGe1WLqwyds
	Fq9fGFqcbXrDbvHtSgeTxeVdc9gsZpzfx2Sx9shddouLK74wWayf8ZrFYs70d0wO3B47Z91l
	99i0qpPNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDImrDvKVrCJs2LmolmsDYzr2LsYOTkk
	BEwkHm+YzwZhi0lcuLceyObiEBJYyijRNKefEcLpY5JYePskE0gVm4CxxOblS8CqRAQ2Mkoc
	3H+YFcRhFpjJJPHn5gOwKmEBP4mGxg8sIDaLgKrEzn1XgGwODl4BV4lTz1NBTAkBBYk5k2wm
	MHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESQl92MC4+ZnWIUYCDUYmH12CBRLAQ
	a2JZcWXuIUYJDmYlEd6uZslgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzl03UKZN47KhWdym06
	6NGTd52Bb0p49aRzP561Ovco3L00dZdExudsqZMl7+8I3p+9yGq/dFRC6u8lJQXxXTWax492
	mpS6mDq1pB+Z9+rGFeUZSZ+nHn6w6km4rmP9GusehpTX0TZL/8z49Uwty6RL5D7HkTklW6ZE
	HX/IfkN1Zbsa41MdcS0lluKMREMt5qLiRADqjVEy/wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the S2MPS14 device to the s2mps11 regulator
driver. It's a subset of previously sent patches for S2MPS14 device:
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217
along with one new patch:
 - PATCH 2/3: regulator: s2mps11: Add set_suspend_disable for S2MPS14
which replaces previous "opmode" idea.


These patches are rebased against linux-next tree (next-20140305) because
they depend on changes in main MFD sec-core and s2mps11 regulator driver.


Changes since v1
================
1. Patch 2/3: Store information that regulator was suspended.


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  regulator: s2mps11: Add support for S2MPS14 regulators
  regulator: s2mps11: Add set_suspend_disable for S2MPS14
  Documentation: mfd: s2mps11: Document support for S2MPS14

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 +-
 drivers/regulator/Kconfig                         |    9 +-
 drivers/regulator/s2mps11.c                       |  301 ++++++++++++++++-----
 include/linux/mfd/samsung/s2mps14.h               |    2 +
 4 files changed, 255 insertions(+), 69 deletions(-)

-- 
1.7.9.5

