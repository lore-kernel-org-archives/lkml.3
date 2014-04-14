Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaDNJHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:07:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13997 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaDNJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:07:10 -0400
X-AuditID: cbfee68f-b7f156d00000276c-4b-534ba53c2e38
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/2] iio: adc: exynos_adc: Support Exynos3250 ADC
Date: Mon, 14 Apr 2014 18:07:04 +0900
Message-id: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkRNdmqXewwYNlchZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	S69fZLKYMH0ti8XbO9NZLFr3HmG3WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOoGM
	JfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlbH8UDNbQQ9rxdTlN5kbGDtZuhg5OSQETCTe
	znvMCmGLSVy4t56ti5GLQ0hgKaPE+e/nGGGKWg7uZIFILGKUONx3gBXCaWKS6D3VANbOJqAl
	sf/FDTYQW0TASeLnt3tgo5gFOpkl/nXfZwZJCAs4S6y5eh5sN4uAqsSCua/AmnkFXCV2XV/M
	BLFOTuLDnkfsIM0SArfYJT68284M0SAg8W3yIaBmDqCErMSmA8wQ9ZISB1fcYJnAKLiAkWEV
	o2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmDknP73rH8H490D1ocYk4HGTWSWEk3OB0ZeXkm8
	obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgtJ3wK+IL
	h3BAafB+edb7ItO/O17zSW6OFxBzMwhYvMnzuf3Sa+nMB7iZl78WtjmxSeeR6J1JpTs2fuNl
	tE/NnX1UzW3zIe32vNSvpz/1sk4xkFB5Y8USoPnJm7dbgvHCzT1795+Sctsu+KxWsnnKDLP1
	PXF7zx8I4/0Wmhf+YU8221zuH0aPlFiKMxINtZiLihMBggHNU7ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV2bpd7BBvdWi1rcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmsenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	LL1+kcliwvS1LBZv70xnsWjde4TdYv2M1ywOgh5r5q1h9Ljc18vksXL5FzaPzSu0PDat6gQy
	ltR79G1ZxejxeZNcAEdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtAbSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM5Yea
	2Qp6WCumLr/J3MDYydLFyMkhIWAi0XJwJ5QtJnHh3nq2LkYuDiGBRYwSh/sOsEI4TUwSvaca
	WEGq2AS0JPa/uMEGYosIOEn8/HYPrINZoJNZ4l/3fWaQhLCAs8Saq+fBxrIIqEosmPsKrJlX
	wFVi1/XFTBDr5CQ+7HnEPoGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Lh8Jr2D
	cVWDxSFGAQ5GJR7ejjnewUKsiWXFlbmHGCU4mJVEeLdleAUL8aYkVlalFuXHF5XmpBYfYkwG
	2j6RWUo0OR+YMvJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1Oq
	gbHtpmHoh+SDhk93ZO1uuMC+uFyJqa7xpXeCI3+yUyvD1IT50W5+bS+XNyj9PrD6js5XpVbW
	qb/smeOYGJYVnvPWPf6nvjRk2eNUpgDhl9EhBvFXTvbGMnDcj1jOU34/Z9GL71M/L/njphXf
	1cemrXfftP9Yqd4LnvDK22znhcy6G2eILdn5XomlOCPRUIu5qDgRALC4XmQPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP.

Changes from v1:
- Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
- Add a patch about DT binding documentation

Chanwoo Choi (2):
  iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 20 ++++++++
 drivers/iio/adc/exynos_adc.c                       | 54 ++++++++++++++++------
 2 files changed, 61 insertions(+), 13 deletions(-)

-- 
1.8.0

