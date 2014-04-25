Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaDYLgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:36:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16189 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaDYLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:32 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-41-535a48bffede
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 0/5] Add PMU node for Exynos SoCs
Date: Fri, 25 Apr 2014 20:54:12 +0900
Message-id: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+Zoe5+j6hgg4cPuCyWTbrLZjH/yDlW
	i94FV9ksNj2+xmpxedccNosZ5/cxWSza+oXdonXvEXaL9TNes1jsaFnN4sDlsWlVJ5vH5iX1
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx5uMJ5oLP3BXbj61nb2Bs5+xi5OSQEDCRaOzc
	wwZhi0lcuLceyObiEBJYxijRdfswG0zR895lUIlFjBI7j39ghHDamCTu/d/EAlLFJqAr8eT9
	XGaQhIhAO6PEv6sPwVqYBeYySjS3X2AHqRIGmnVixztmEJtFQFXi+dOnjCA2r4C7xMutD4Bs
	DqB9ChJzJtmAhDkFPCSeLTnKBGILAZW8WHSHHWSmhMA6domnh5ZDzRGQ+Db5EAtEr6zEpgPM
	EGdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxghwd+/g/HuAetDjMlA
	4yYyS4km5wOjJ68k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MDreE+ffo1+tkL1aWc6lcQL3Tk9FbbW5kbHbbfcVtyjwuZYeUDl0WXTq2yTGwoqA
	r0YGTnf2Ot2O1jkaNbHneNStabcuXy27E6H5Sc3Z9mHkJxfV3c93ZVR5VoRk72I+GrHL6gK7
	8/t5qdJb1JdzLnt7fFrH0gOGMZ4iprmPpfU6wg/NSjqrpMRSnJFoqMVcVJwIAIWxfV6UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd39HlHBBksnsVksm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpuPJ5gL
	PnNXbD+2nr2BsZ2zi5GTQ0LAROJ57zI2CFtM4sK99UA2F4eQwCJGiZ3HPzBCOG1MEvf+b2IB
	qWIT0JV48n4uM0hCRKCdUeLf1YdgLcwCcxklmtsvsINUCQPNPbHjHTOIzSKgKvH86VNGEJtX
	wF3i5dYHQDYH0D4FiTmTbEDCnAIeEs+WHGUCsYWASl4susM+gZF3ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzg2HomtYNxZYPFIUYBDkYlHt4PapHBQqyJZcWVuYcYJTiYlUR4212j
	goV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5Hxj3eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXA6CDy+UKebVlvXpexa8DL47ouNnsl/h023Jst+W/lLLZ3
	CWJy5jvOXt3FuzEs0zNyiWEK05vHUlUxnK9OVTs35l/4WfTAcgnPtjU6ktNqok+uupmv9p1J
	r6ktVP1gj8MzvwbphVPMN5VOj79QIv5rxcbW7Z+NfSca1e15G2rx6m05i+cNRr9PSizFGYmG
	WsxFxYkASY7dWfECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds new property in samsung PMU binding as
"samsung,syscon-phandle" to get PMU regmap handle in PMU driver
implementation and "mach-exynos/exynos.c".
This patch also updates Exynos4210, Exynos4412 and Exynos4212 dtsi files
for adding PMU (Power Management Unit) reg node.
Updated binding document for the same.

These patches are required for converting PMU implementation free from
static mapping of PMU registers as well as it's dependency from machine
header files, thus allowing us to converting it into DT based.

Changes since v1:
 - Added new property "samsung,syscon-phandle" to get access to PMU regmap handle.
 - Updated Exynos5250, Exynos5420, Exynos4210/4412/4212 dtsi files.
 - Rebased on Kukjin Kim's for-next branch.

Pankaj Dubey (5):
  ARM: dts: Add syscon handle in pmu node for exynos5250
  ARM: dts: Add PMU node to exynos4210
  ARM: dts: Add PMU node to exynos4212 and exynos4412
  arm: dts: Add syscon handle in pmu node for exynos5420
  Documentation: update samsung pmu binding information

 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    7 +++++++
 arch/arm/boot/dts/exynos4210.dtsi                     |    6 ++++++
 arch/arm/boot/dts/exynos4212.dtsi                     |    6 ++++++
 arch/arm/boot/dts/exynos4412.dtsi                     |    6 ++++++
 arch/arm/boot/dts/exynos5250.dtsi                     |    1 +
 arch/arm/boot/dts/exynos5420.dtsi                     |    1 +
 6 files changed, 27 insertions(+)

-- 
1.7.10.4

