Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaCQJTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:19:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34083 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaCQJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:19:29 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-37-5326be1f8b3d
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
Subject: [PATCH v3 0/3] clk: s2mps11: Add support for S2MPS14 clocks
Date: Mon, 17 Mar 2014 10:19:15 +0100
Message-id: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4VV35fWrBBsduK1psnLGe1eL1C0OL
	s01v2C3ufz3KaLHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xkszj5p5fR4nQ3q8XFFV+YLNbP
	eM1i0f53L5vFnOnvmBz4Pe5c28PmMe9koMfmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fA
	lfG94wpzwSmuihVrprE2MDZydDFyckgImEj8ntbADGGLSVy4t56ti5GLQ0hgKaPEvJZGFgin
	j0li4vo/bCBVbALGEpuXLwGrEhFoZpLY9/UxE4jDLPCWSeLOoZvsIFXCAi4SHduWMoLYLAKq
	EntubWICsXkF3CW+zDzI2sXIAbRPQWLOJJsJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl
	5+duYoQE3JcdjIuPWR1iFOBgVOLhnaCsFizEmlhWXJl7iFGCg1lJhLd0G1CINyWxsiq1KD++
	qDQntfgQIxMHp1QD48y1ElWMXKVajTMXv11yw8nzkwNz/uy6827x6tJ5SZ5SheWrD1UecDg5
	Jds+4Wl4o+kvoxaeG9Ux564+7Aq9ckdsufff/1vYZzvnq69lWOoy82rpmYlc52S/MygHrO3u
	e7P3TJ+QiKX7LMYXEUuUU6RbXdaW6/OILLsfe+P3b7mUoJmhQawrlFiKMxINtZiLihMBWWMk
	mhYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is third version of patchset adding support for the S2MPS14
device to the s2mps11 clock driver.


The patchset *depends on*:
==========================
1. Work done by Tushar Behera:
   [PATCH V2 0/2] Add support for clocks in S5M8767
   http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27264
2. Support for S2MPS14 in main sec-core MFD driver (already in linux-next
   and Lee's tree).

Changes since v2:
=================
1. Patch 2/3: Remove MFD cells of_compatible which aren't used by child
   drivers and are not documented.
2. Added Tomasz's Review-by.

Changes since v1:
=================
1. Patch 1/3: Update driver description in Kconfig.
2. Patch 2/3: Add of_compatible to all MFD cells.
3. Add Yadwinder's Review-by.

Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  clk: s2mps11: Add support for S2MPS14 clocks
  mfd: sec-core: Add of_compatible strings for clock MFD cells
  Documentation: mfd: s2mps11: Describe S5M8767 and S2MPS14 clocks

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   24 +++++---
 drivers/clk/Kconfig                               |    8 +--
 drivers/clk/clk-s2mps11.c                         |   61 ++++++++++++++++-----
 drivers/mfd/sec-core.c                            |    3 +
 4 files changed, 68 insertions(+), 28 deletions(-)

-- 
1.7.9.5

