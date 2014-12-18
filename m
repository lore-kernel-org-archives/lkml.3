Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaLRNQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:16:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaLRNPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:15:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-10-5492d3840f8b
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 0/3] power: rt5033: Add Richtek RT533 drivers
Date: Thu, 18 Dec 2014 22:15:44 +0900
Message-id: <1418908547-10241-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkWLfl8qQQg+sLdCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4tyrlYwWk+5PYLF4v+cMo8W3Kx1MFpd3zWGz
	+Nx7hNFi6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUWMya/ZHMQ9lgzbw2jx+W+XiaPnbPusnus
	XP6FzWPzCi2PTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFcEVx2aSk5mSWpRbp2yVwZdztPctU
	cIyz4t+qY2wNjCvYuxg5OSQETCQ2LO9jhLDFJC7cW8/WxcjFISSwlFFi6o5WZpiiBUdXgtlC
	AosYJVY+D4QoamOS2HPkACtIgk1AU+L9lCssILaIQITE2WWzwGxmgZ9MEjcvZYPYwgK2EhvX
	ngXbxiKgKjFj6lGgXg4OXgE3iXdLNUBMCQEFiTmTbEDGSwj8ZJeYMv0vVLmAxLfJh1ggamQl
	Nh2AOk1S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMqtP/nk3cwXj/
	gPUhRgEORiUeXgm9SSFCrIllxZW5hxhNgTZMZJYSTc4Hxm5eSbyhsZmRhamJqbGRuaWZkjiv
	jvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MZx05RDLnKhjYXvgecpbtsoRyo22Fy2Fd
	OfUXWyr5Z0SFL9b7ZlJ6JOm24t4v3Rd544O0jI6oKZivquea5LomfdKcRbcE9nR2s+wxYfNe
	VXw0fqnGgsoVf6b6rCz8c/a8xo6aFpPTsTE3/056lxZ5rnnNNeYz+k+MfT0TtnntTbly/XXF
	4gPGSizFGYmGWsxFxYkAvuSx2KUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd2Wy5NCDM5OVLY4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJaTLo/gcXi/Z4zjBbfrnQwWVzeNYfN
	4nPvEUaLpdcvMllMmL6WxaJ17xF2i9PdrBand5dYzJj8ks1B2GPNvDWMHpf7epk8ds66y+6x
	cvkXNo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SYkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjHjbu9ZpoJjnBX/Vh1ja2Bcwd7FyMkhIWAiseDoSmYIW0ziwr31
	bCC2kMAiRomVzwO7GLmA7DYmiT1HDrCCJNgENCXeT7nCAmKLCERInF02C8xmFvjJJHHzUjaI
	LSxgK7Fx7VlGEJtFQFVixtSjQL0cHLwCbhLvlmqAmBICChJzJtlMYORewMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4Zp9J7WBc2WBxiFGAg1GJh1dCb1KIEGtiWXFl7iFGCQ5mJRHe
	6BygEG9KYmVValF+fFFpTmrxIUZToN0TmaVEk/OB6SSvJN7Q2MTMyNLI3NDCyNhcSZxXyb4t
	REggPbEkNTs1tSC1CKaPiYNTqoFR6BYPa0TXozRZCZ95FQyTdhaZfVjxbnfGlLiLvpo2nfn3
	3B4keEuWcF9eOq394IrLEoVRbm7mSgLb9z9ebhcxwU/T62HopQ0zveL6PeRKdC4sPf3Srq4m
	3OO8vZtuRYr9qws/9G838e1flaK55P5S99Xlt5aultS0sohmNrpipDKj5P5y/k1KLMUZiYZa
	zEXFiQCO4mA/7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds driver for Richtek rt5033 chip The chip contains
switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
Additionally, This includes document for device tree of RT5033 device.

RT5033 core driver is applied by Lee Jones.
RT5033 regulator driver have been merged by Mark Brown. commit is below,

commit b1917578fd5d8efa67afa05a0d6d7e323f2802da

Beomho Seo (3):
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 6 files changed, 789 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c

-- 
1.7.9.5

