Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaG1MoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:44:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12974 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaG1MoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:44:08 -0400
X-AuditID: cbfee691-b7f306d000003d81-1e-53d64594e8f4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, heiko@sntech.de, knaack.h@gmx.de,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/3] iio: adc: exynos_adc: Add support for s3c64xx/s3c24xx ADC
Date: Mon, 28 Jul 2014 21:43:59 +0900
Message-id: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSqDvV9VqwwXEri7+TjrFb3H1+mNHi
	+pfnrBbzj5xjtfj/6DWrxYOmVUwWvQuuslns+v+G2eJs0xt2i02Pr7FaLGxbwmIx78g7FovL
	u+awWcw4v4/JYv2M1ywO/B6/f01i9PjwMc5j06pONo/NS+o9+rasYvTYfm0es8fnTXIB7FFc
	NimpOZllqUX6dglcGZ3XF7EULOas+HloCXMD42r2LkYODgkBE4lVLwW6GDmBTDGJC/fWs3Ux
	cnEICSxllDh57BozRMJEYtLXNywQiUWMEhePbWGEcJqYJOYe+csOUsUmoCWx/8UNNhBbREBE
	4t7pD4wgNrPATyaJHU+LQGxhgQCJBZveMIHYLAKqEvvPdoHV8Aq4SjTOv8sGsU1O4sOeR+wg
	CyQEjrFLbD1xG6pBQOLb5EMsEGfLSmw6AHWdpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqlec
	mFtcmpeul5yfu4kRGBWn/z2buIPx/gHrQ4zJQOMmMkuJJucDoyqvJN7Q2MzIwtTE1NjI3NKM
	NGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhnRgr8q1J5tExT2i6jQOJ4cKNV
	lqxIWlCvvrXUdItNyyV4+h4lvWq4JN1cotzisdU5984Ov86eJ/NW/LLmz9t4s7nq5xINM55i
	ocLdx9LcVq7TdowUrAl9Pkfee9bR1fVMdxgPiKxIO/BlQpn2M4ejaaeENgll/gx8dDd77jl/
	QfXYqig3byWW4oxEQy3mouJEADqaiM+gAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd0prteCDY4sMLX4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaL/49es1o8aFrFZNG74Cqbxa7/b5gtzja9YbfY9Pgaq8XCtiUsFvOOvGOx
	uLxrDpvFjPP7mCzWz3jN4sDv8fvXJEaPDx/jPDat6mTz2Lyk3qNvyypGj+3X5jF7fN4kF8Ae
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0t5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo/P6IpaCxZwVPw8tYW5gXM3e
	xcjJISFgIjHp6xsWCFtM4sK99WxdjFwcQgKLGCUuHtvCCOE0MUnMPfIXrINNQEti/4sbbCC2
	iICIxL3THxhBbGaBn0wSO54WgdjCAgESCza9YQKxWQRUJfaf7QKr4RVwlWicf5cNYpucxIc9
	j9gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcd8+kdzCuarA4xCjAwajEw2sR
	fDVYiDWxrLgy9xCjBAezkgivtdO1YCHelMTKqtSi/Pii0pzU4kOMpkDbJzJLiSbnA1NCXkm8
	obGJmZGlkbmhhZGxuZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRnU1ppnHfpj92hHVJbru
	OWPKpjbmHKYNC79O0kud/CRUguHHg+XOXL7HJvW9yV53auraS+e27rFPSM4VnFyqWLVy+ap5
	jhEBrhem7TBLbmBuVJU9GHHXIMc4UfuDFl942C3VViErlW9KcfyfD606HOxsfOffjYCUGxNW
	lJc+Ef+S/klA5ixHlhJLcUaioRZzUXEiAC9Cga3RAgAA
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
- s3c24xx/s3c64xx has not included ADC_PHY enable register

Changes from v1:
- Fix minor coding style.
- Remove the sentence which reading DATY register.
- Add ARCH_S3C24XX / ARCH_S3C64XX dependency for EXYNOS_ADC to Kconfig.
- Remove the function pointer of 'clear_irq' for s3c24xx becase s3c24xx
  has not included ADC_V1_INTCLR register.
- Remove un-necessary white-space in dt-binding documentation

Arnd Bergmann (1):
  iio: adc: exynos_adc: add support for s3c64xx adc

Chanwoo Choi (2):
  iio: adc: exynos_adc: Add support for s3c24xx ADC
  dt-bindings: samsung: exynos_adc: Remove un-necessary white-sapce

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  20 ++-
 drivers/iio/adc/Kconfig                            |   2 +-
 drivers/iio/adc/exynos_adc.c                       | 137 +++++++++++++++++++--
 3 files changed, 144 insertions(+), 15 deletions(-)

-- 
1.8.0

