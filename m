Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaEJG2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:28:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaEJG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:28:11 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ab-536dc6f8ba8d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 0/3] Add PMU node for Exynos4 SoCs
Date: Sat, 10 May 2014 15:46:22 +0900
Message-id: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t8zI92fx3KDDfrMLZZNustmMf/IOVaL
	3gVX2Sw2Pb7GanF51xw2ixnn9zFZLNr6hd2ide8Rdov1M16zWOxoWc3iwOWxaVUnm8fmJfUe
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlbHn3T/mgrs8FZtmyzYw/uLsYuTgkBAwkTj8gauL
	kRPIFJO4cG89WxcjF4eQwDJGiQWX7rPA1Mz8HQ8RX8Qo8fPUaWYIp41J4tn+w+wg3WwCuhJP
	3s8FS4gItDNK/Lv6EGwUs8BcRonm9gtgVcICphJdT+4yg9gsAqoSX9Z3MIHYvAIeEtNXbGGD
	WKcgMWeSDUivhMBkdoljz1YzQtQLSHybfAjqJFmJTQeYIc6WlDi44gbLBEbBBYwMqxhFUwuS
	C4qT0ouM9YoTc4tL89L1kvNzNzFCgrh/B+PdA9aHGJOBxk1klhJNzgdGQV5JvKGxmZGFqYmp
	sZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJwfdTBkky97mjmridnk
	T9GdLtMk7fyKH4l/evbhVUqWweV63RvvrJVNf/UrNC6+wRwnc0aluYNVvdPuXU30jNOPJBfO
	f3MxX0WljGGpqBr3PN8Ly6f/PpTSe2vzr3szvjG3FMxO+5Ly3P1Yu27vuR2fpY+aPDrx/rRn
	Hm9w1vSPC06t7UvXdVBiKc5INNRiLipOBAAar3jxeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jAd0fx3KDDTrOWVgsm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp53/5gL
	7vJUbJot28D4i7OLkYNDQsBEYubv+C5GTiBTTOLCvfVsXYxcHEICixglfp46zQzhtDFJPNt/
	mB2kik1AV+LJ+7lgCRGBdkaJf1cfgrUwC8xllGhuvwBWJSxgKtH15C4ziM0ioCrxZX0HE4jN
	K+AhMX3FFjaI1QoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOE6eSe9g
	XNVgcYhRgINRiYe38G1OsBBrYllxZe4hRgkOZiUR3hUHc4OFeFMSK6tSi/Lji0pzUosPMSYD
	LZ/ILCWanA+M4bySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRq
	YFyieKh80753Of8UjoTe2Hj8ptOKQ/eS531UaE54fWra/0qJ6jrNyTdeNtlc5L21+IHvDd0v
	b7vZEwK/XVVV28hrZlA2uUPxe7HptGUyipOv85dc3Ojz1rMiw1HU7F4u+6lrHN8EPqdbrtsY
	LMyyV9Zvx47yr2dYYo+uT7l+fFU136tUdd9Hhy2UWIozEg21mIuKEwHWEDp+1wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates Exynos4210, Exynos4412 and Exynos4212 dtsi files
for adding PMU (Power Management Unit) reg node.
Updated binding document for the same.

These patches are required for converting PMU implementation free from
static mapping of PMU registers as well as it's dependency from machine
header files, thus allowing us to converting it into DT based.

Revision 2 was posted here 
 - https://lkml.org/lkml/2014/4/25/216 

Changes since v2:
 - Dropped addition of new property followed by one simple fix in syscon driver
   posted here [1].
 - Addressed review comments [2] by Tomasz Figa about property pointing back to
   self device node.
 - Updated binding doc with example.

Changes since v1:
 - Added new property "samsung,syscon-phandle" to get access to PMU regmap handle.
 - Updated Exynos5250, Exynos5420, Exynos4210/4412/4212 dtsi files.
 - Rebased on Kukjin Kim's for-next branch.

[1]: Allow NULL property in syscon_early_regmap_lookup_by_phandle
     https://lkml.org/lkml/2014/5/10/10 and
     https://lkml.org/lkml/2014/4/29/661

[2]: https://lkml.org/lkml/2014/4/25/762

Pankaj Dubey (3):
  ARM: dts: Add PMU node to exynos4210
  ARM: dts: Add PMU node to exynos4212 and exynos4412
  Documentation: update samsung pmu binding information

 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    3 +++
 arch/arm/boot/dts/exynos4210.dtsi                     |    5 +++++
 arch/arm/boot/dts/exynos4212.dtsi                     |    5 +++++
 arch/arm/boot/dts/exynos4412.dtsi                     |    5 +++++
 4 files changed, 18 insertions(+)

-- 
1.7.10.4

