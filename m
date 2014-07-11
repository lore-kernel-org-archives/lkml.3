Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGKJKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:10:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16778 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaGKJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:42 -0400
X-AuditID: cbfee68f-b7fef6d000003970-0e-53bfaa0fee62
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: [PATCH 0/4] iio: exynos-adc: use syscon instead of ioremap
Date: Fri, 11 Jul 2014 14:36:25 +0530
Message-id: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkTpd/1f5ggyX/zSxeHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e+yfu4bdY8mbQ6wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlTFn5Semgr08FR0n/rA0MD7i
	7GLk5JAQMJH48H0ZM4QtJnHh3nq2LkYuDiGBpYwSkw5PZIIpOtxzmQkiMZ1R4vLbE4wQTj+T
	xIaW16wgVWwCZhIHF61mB7FFBOIkPlzuZwcpYhZYyyjRtu0qWEJYwFni35FrYPtYBFQlTr/u
	AVvBK+Aq8bThPZDNAbROQWLOJBuQXgmBRewSa+6cYIeoF5D4NvkQC0SNrMSmA1BnS0ocXHGD
	ZQKj4AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgeF9+t+z/h2Mdw9YH2JMBho3kVlK
	NDkfGB95JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoGRR63emE9kS7uxlcaWn33FVZ2uM6QPx0TZ/pbQ7J/fHroyMXO26ZEdrxZxOWxdv3XfM7mC
	6OwdBot6rU/UrDjvcz69umN/JeP3ZdLTZjJo2HXH6d9X1T/nsW0nQ2C84sZTfVHPJhv6d+o/
	em1wzFqI48S9y5P+79Aq7DjxW7qyTcuYj3dSrJgSS3FGoqEWc1FxIgAajverhQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd0XK/cHG0y9Y2Tx8pCmxfUvz1kt
	5h85x2rRvHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MDlwesxsusnjsnHWX
	3WP/3DXsHkveHGL16NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKDTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZc1Z+YirYy1PRceIPSwPjI84uRk4OCQETicM9l5kgbDGJC/fWs3UxcnEICUxnlLj8
	9gQjhNPPJLGh5TUrSBWbgJnEwUWr2UFsEYE4iQ+X+9lBipgF1jJKtG27CpYQFnCW+HfkGjOI
	zSKgKnH6dQ/YCl4BV4mnDe+BbA6gdQoScybZTGDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOHqeSe1gXNlgcYhRgINRiYdXYf2+YCHWxLLiytxDjBIczEoivE/q9wcL8aYkVlal
	FuXHF5XmpBYfYjQFWj6RWUo0OR8Y2Xkl8YbGJuamxqaWJhYmZpZK4rwHWq0DhQTSE0tSs1NT
	C1KLYPqYODilGhiTWjV+z+hufmTCxXzxqj9reJr2HmabF37PVuuvY0+ayWYewpkyX47XofFk
	Z/aqrV46M14+dT9m/Idvwcos/Scn/s5x3MzbPv2NiM0x1s0/4qUz3AJ0eXpKjCRtF+3x/GUn
	x3LkeNC9Xa98Xl6x+r45XnBhqeyd89ynzOpOXzkoXfVHONnw0EIlluKMREMt5qLiRAAuFoqF
	tAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following
1. Use the syscon and Regmap API instead of ioremappaing the
   ADC_PHY register from PMU.
2. Moves the exynos-adc.txt from bindings/arm/samsung/
   to bindings/iio/adc/.
3. Updates the Documentation in exynos-adc.txt with syscon phandle
   for the ADC nodes.
4. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
   Exynos5420 with the syscon phandle.

Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
by verifying sysfs entries provided by HWMON based NTC thermistors.

Tested-By for Exynos3250, Exynos4x12 would be appreciated.

Naveen Krishna Chatradhi (4):
  iio: exyno-adc: use syscon for PMU register access
  Documentation: dt-bindings: move exynos-adc.txt to more iio/adc/
  Documentation: dt-bindings: update exynos-adc.txt with syscon handle
  ARM: dts: exynos: Add sysreg phandle to ADC node

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   82 ------------------
 .../devicetree/bindings/iio/adc/exynos-adc.txt     |   87 ++++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
 drivers/iio/adc/exynos_adc.c                       |   29 +++++--
 7 files changed, 115 insertions(+), 95 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/exynos-adc.txt

-- 
1.7.9.5

