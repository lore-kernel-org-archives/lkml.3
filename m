Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3JJAaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:30:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33892 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3JJAaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:30:25 -0400
X-AuditID: cbfee68e-b7f756d000004512-9f-5255f50c8fca
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/3] ARM: dts: exynos: Add missing dt data to bring up kernel
 feature
Date: Thu, 10 Oct 2013 09:30:04 +0900
Message-id: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSosvzNTTI4OwKUYvrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgARxSX
	TUpqTmZZapG+XQJXxsY9L1kLJrNUbLzcw9zAuIy5i5GDQ0LAROLPAf8uRk4gU0ziwr31bF2M
	XBxCAksZJZ4umcsCkTCRmPDtNiNEYjqjxPb986GcRiaJVevbmEGq2AS0JPa/uAHWLiLQziix
	unUBC4jDLNDKJHF1yy6wKmGBcIl9a+eC2SwCqhJXfzSzgdi8Ai4SR55OYoLYJyfxYc8jdpBm
	CYFj7BITD6xmg2gQkPg2+RALxOGyEpsOMEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrF
	ibnFpXnpesn5uZsYgZFx+t+zvh2MNw9YH2JMBho3kVlKNDkfGFl5JfGGxmZGFqYmpsZG5pZm
	pAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamD0nbMy1+vBQ47Py9J1OH5ta1/B
	evC9+ry3GwxivrwzdU5rOH2H0eyZW94r7q8OW9PDF3dveKgb8ufDR9M84SU1m6cHKjna2wY2
	WszenSvxZ/2Chy1iwhbfPM3P2dcHevucP7nkXHiKx7FOtotCan/YhE726B7/l9FwVvbF7rcm
	srO3buJsf7RKiaU4I9FQi7moOBEAf58fo6ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jQV2er6FBBh3veC2uf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDM27nnJWjCZpWLj5R7mBsZlzF2M
	nBwSAiYSE77dZoSwxSQu3FvP1sXIxSEkMJ1RYvv++YwQTiOTxKr1bWAdbAJaEvtf3ACrEhFo
	Z5RY3bqABcRhFmhlkri6ZRdYlbBAuMS+tXPBbBYBVYmrP5rZQGxeAReJI08nMUHsk5P4sOcR
	+wRG7gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiPvmdQOxpUNFocYBTgYlXh4K8pC
	g4RYE8uKK3MPMUpwMCuJ8E4/CRTiTUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjAp5JXEGxqb
	mBlZGpkbWhgZm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY6GXiEhPefrDA63vHeKf
	bfnEfahiu3iIypturVqlhYunn7pZuFZTbbFg3yXOtORFmpNKhBfaX1odlLDW1vj06+1GPyf4
	PLdVntgf9OCw6O+fbs7/Tt2ytUj6y12o4WPpEKVYse9D/cJ9a7xmhRd5Ll996Jby0z3nyjcv
	W/V12pMULmcHduHmmUosxRmJhlrMRcWJAMIUC8sAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add missing dt data to bring up kernel feature
- MAUDIO/GPS_ALIVE power domain
- PMU 
- Clock data for Multi core timer

Chanwoo Choi (2):
  ARM: dts: exynos4212: Add PMU dt data for pmu-irq
  ARM: dts: exynos4x12: Add maudio/gps_alive power domain for exynos4x12

Marek Szyprowski (1):
  ARM: dts: exynos4212: Add missing clock for multi core timer

 arch/arm/boot/dts/exynos4212.dtsi |  8 ++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
 2 files changed, 18 insertions(+)

-- 
1.8.0

