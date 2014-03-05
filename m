Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaCEJXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:23:10 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46857 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaCEJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:23:04 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b4-5316ecf343aa
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] regulator: s2mps11: Add support for S2MPS14 regulators
Date: Wed, 05 Mar 2014 10:22:50 +0100
Message-id: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Nd3Pb8SCDXatMrbYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xltzj5p5fR4nQ3q8XFFV+YLNbP
	eM1iMWf6OyYHPo+ds+6ye2xa1cnmcefaHjaPeScDPfq2rGL0+LxJLoAtissmJTUnsyy1SN8u
	gSujb99x1oKTHBVH1l5jbGC8zdbFyMkhIWAisfPmHSYIW0ziwr31QHEuDiGBpYwS63b8YYRw
	+pgkfh35yghSxSZgLLF5+RKwKhGB34wSPefusoM4zAKHmSTuvf0LlOHgEBbwlli/OxykgUVA
	VeLGsedg63gF3CS2r//OAlIiIaAgMWeSzQRG7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLz
	czcxQgLu6w7GpcesDjEKcDAq8fC+4BALFmJNLCuuzD3EKMHBrCTCm/ICKMSbklhZlVqUH19U
	mpNafIiRiYNTqoExbMaHiyU++93e2ORyCvzQWjPvZ0Tu/H0nitwLoypnds890nvLzNJ25rTa
	73Z/dc57f248w9Z6N3lFUOt96V3nLq0+/jhzZuSTjDRxlcgWeenD/f9y9r74a8Zx7MPdTnlj
	Z+YETpen5c7S5iqabeEt2XNPBH8p6pktMj9jzW3b0j/evB/eb/RWYinOSDTUYi4qTgQAun35
	rBYCAAA=
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


Best regards,
Krzysztof

Krzysztof Kozlowski (3):
  regulator: s2mps11: Add support for S2MPS14 regulators
  regulator: s2mps11: Add set_suspend_disable for S2MPS14
  Documentation: mfd: s2mps11: Document support for S2MPS14

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 +-
 drivers/regulator/Kconfig                         |    9 +-
 drivers/regulator/s2mps11.c                       |  278 ++++++++++++++++-----
 include/linux/mfd/samsung/s2mps14.h               |    2 +
 4 files changed, 232 insertions(+), 69 deletions(-)

-- 
1.7.9.5

