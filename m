Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbaFZMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:22:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9700 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbaFZMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:22:31 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-c0-53ac108590ac
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com
Subject: [PATCH 0/3] ARM: DTS: create common dtsi for Peach pit and pi boards
Date: Thu, 26 Jun 2014 17:49:05 +0530
Message-id: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkVrdVYE2wwf5HvBYvD2lazD9yjtXi
	7LKDbBbNi9ezWcw78o7F4vKuOWwWM87vY7JYtO0/swOHx+yGiyweO2fdZffYP3cNu0ffllWM
	Hp83yQWwRnHZpKTmZJalFunbJXBlHJ7RxVKwm6Pi+MU3jA2MX9i6GDk5JARMJG5tuwVli0lc
	uLcezBYSWMooMeFxEUzN8dufmboYuYDi0xklGp7MZoNw+pkkDs6cwgpSxSZgJnFw0Wp2EFtE
	wFFix5x/YB3MAgsYJVp3rWYCSQgL+Ep8utEMZrMIqEocW3wdrIFXwFWi7/4foEEcQOsUJOZM
	sgHplRBoZ5dovdfECFEvIPFt8iEWiBpZiU0HmCGuk5Q4uOIGywRGwQWMDKsYRVMLkguKk9KL
	jPSKE3OLS/PS9ZLzczcxAsP39L9nfTsYbx6wPsSYDDRuIrOUaHI+MPzzSuINjc2MLExNTI2N
	zC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj7dXqOu7sNU1XU0IDooOX
	fGh+n2OvcUScYb6MvMFtxmcfpoTuf1Gq+T1rY8zlg0crBCs83Oo7J0q+PRLPLMn6cK6Dlsoy
	fYscpno2mbW6vU8qbhp1n9x7Y8v7RVcScrQDd7+7LLB5cZzI4ysH7oZrbqvw5Hh+YiLHmqij
	Gxlbn8Vd73KffcdPiaU4I9FQi7moOBEAhlMRZ3UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQd1WgTXBBounsFm8PKRpMf/IOVaL
	s8sOslk0L17PZjHvyDsWi8u75rBZzDi/j8li0bb/zA4cHrMbLrJ47Jx1l91j/9w17B59W1Yx
	enzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePwjC6Wgt0cFccv
	vmFsYPzC1sXIySEhYCJx/PZnJghbTOLCvfVAcS4OIYHpjBINT2ZDOf1MEgdnTmEFqWITMJM4
	uGg1O4gtIuAosWPOPyaQImaBBYwSrbtWg40SFvCV+HSjGcxmEVCVOLb4OlgDr4CrRN/9P0CD
	OIDWKUjMmWQzgZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg+HgmtYNxZYPFIUYB
	DkYlHt4Pj1cFC7EmlhVX5h5ilOBgVhLhFfm9OliINyWxsiq1KD++qDQntfgQoynQ8onMUqLJ
	+cDYzSuJNzQ2MTc1NrU0sTAxs1QS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwBjPWbHgVvac
	dXqLqr5dYV93RW+7wLqHtoVsf5a81mcR4zM9MtMhahmzv9O3SR3Z7PMOuz+r2Cr1vixn4fmW
	nBnuAr/WR/qqXnp888+5lVte5aoeZb0XdShFM6Wj1WNfLaP/s35zjU0/tFXuWF7K26hc2PtT
	JWSOgYRcf8PLq1s7SlomSnGuMFRiKc5INNRiLipOBAAzfMwrpQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does the following
1. Create a common dtsi file cros-exynos-peach.dtsi for
   exynos5420-peach-pit.dts and exynos5800-peach-pi.dts
2. Adds the ADC based Thermistor nodes and enables them in peach_pit.dts
   and peach_pi.dts
3. Adds the ADC based Thermistor nodes for Exynos5250 based Snow
4. Corrects the vendor prefix for thermistors in exynos4412-trats2.dts

Naveen Krishna Chatradhi (3):
  ARM: DTS: use new compatible string for thermistors in trats2
  ARM: DTS: Add NTC thermistor nodes to Exynos5250 based Snow
  ARM: DTS: Add common dts file for Peach PIT and PI along with ADC
    nodes

 arch/arm/boot/dts/cros-exynos-peach.dtsi   |   41 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4412-trats2.dts    |    4 +--
 arch/arm/boot/dts/exynos5250-snow.dts      |   34 +++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts |    6 ++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  |    6 ++++
 5 files changed, 89 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/cros-exynos-peach.dtsi

-- 
1.7.9.5

