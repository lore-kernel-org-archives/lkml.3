Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaGVCLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:11:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11640 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaGVCLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:11:19 -0400
X-AuditID: cbfee690-b7fb56d000003439-12-53cdc845cba1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] iio: adc: exynos_adc: Add support for s3c64xx/s3c24xx ADC
Date: Tue, 22 Jul 2014 11:11:12 +0900
Message-id: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkQNf1xNlgg1VPdSz+TjrGbnH3+WFG
	i+tfnrNazD9yjtXiQdMqJoveBVfZLM42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGj02rOtk8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6M59dXMRc0
	slVc6pnA2sD4iqWLkZNDQsBEYtWVc0wQtpjEhXvr2boYuTiEBJYySjxqbGPuYuQAK9rWIwUR
	n84o8WftKyYIp4lJYsbkPawg3WwCWhL7X9xgA7FFBEQk7p3+wAhSxCxwlUli+4717CAJYQE/
	ibPXHjGC2CwCqhLb938Ca+AVcJHYcfMU1ElyEh/2PGIHaZYQ2MQu0f7kJ1SDgMS3yYdYIE6S
	ldh0gBmiXlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAz50/+eTdjB
	eO+A9SHGZKBxE5mlRJPzgTGTVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MdRXqzpK2fZlGzUsNegXqZcOrjkQdSdAuOntX3maK5bMrV6+Y6G04
	z7Cl6Mm8+Ufrs5SUJGVW3Nl/vmjv/UX/TZdFly1Mne+5PlLLf0H3Ac79D9zPf1D+81wy20/K
	R36F50Q9tozOWw3/f98qu/uNyddQ9/vG/f8ntanWLRAtv//L0TtDr36CEktxRqKhFnNRcSIA
	E9Rmto8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQV3XE2eDDdatV7H4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaLB02rmCx6F1xlszjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPTat6mTz2Lyk3qNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZjy/voq5oJGt4lLPBNYGxlcsXYwcHBICJhLbeqS6GDmBTDGJC/fW
	s3UxcnEICUxnlPiz9hUThNPEJDFj8h5WkCo2AS2J/S9usIHYIgIiEvdOf2AEKWIWuMoksX3H
	enaQhLCAn8TZa48YQWwWAVWJ7fs/gTXwCrhI7Lh5igVinZzEhz2P2Ccwci9gZFjFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERxRz6R3MK5qsDjEKMDBqMTDO0HxbLAQa2JZcWXuIUYJDmYl
	Ed72PUAh3pTEyqrUovz4otKc1OJDjKZA2ycyS4km5wOjPa8k3tDYxMzI0sjc0MLI2FxJnPdg
	q3WgkEB6YklqdmpqQWoRTB8TB6dUA+OWw18f/Jt+oIfd0/mI14MFGuezMn/xfN42w9TLPVbT
	YErtghRLLtYzq099+tyU+az3R/k12y8/Pno8mT+vSc97+vcj8jVVcV9FP17YNetFSBTfrLJj
	X3lKRer/9x/Z7LJP4Xtl0LnVV02MX4Vbrm2coXxBitftyJfzl3SbFLrqjCr0TR9rStcosRRn
	JBpqMRcVJwIAWQshcb4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for s3c64xx/s3c24xx ADC. s3c64xx/s3c24xx is alomost same
as ADCv1. But, s3c64xx/s3c24xx has a little difference from ADCv1 as following:
- ADCMUX register address to select channel
- ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)

This patchset is implemented based on exynos3250 ADC patchset[1].
 [1] http://www.spinics.net/lists/kernel/msg1791299.html

Arnd Bergmann (1):
  iio: adc: exynos_adc: add support for s3c64xx adc

Chanwoo Choi (1):
  iio: adc: exynos_adc: Add support for S3C24xx ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  12 +-
 drivers/iio/adc/exynos_adc.c                       | 121 ++++++++++++++++++++-
 2 files changed, 129 insertions(+), 4 deletions(-)

-- 
1.8.0

