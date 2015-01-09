Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbbAIIpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:45:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34193 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbbAIIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:45:18 -0500
X-AuditID: cbfee68e-f79b46d000002b74-bc-54af951c95a9
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v2 0/3] power: rt5033: Add Richtek RT533 drivers
Date: Fri, 09 Jan 2015 17:45:10 +0900
Message-id: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkUFdm6voQg/OreSxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4vGsOm8Xn3iOMFkuvX2Sy
	mDB9LYtF694j7Band5dYzJj8ks1BwGPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBntd6ayFfzirNj+tIG5gfECexcjB4eEgInEruUc
	XYycQKaYxIV769m6GLk4hASWMkrMv/OCCSJhIjHtzhNGiMQiRom5H7+wQDhtTBI33vWwglSx
	CWhKvJ9yhQXEFhHIkNjeMYUZpIhZYBmTxLnWQ8wgCWEBB4mjTdvAxrIIqEqsb90C1swr4Cbx
	cuFTFoiTFCTmTLIB6ZUQuMUucfzBUjaIegGJb5MPQdXISmw6wAxxnaTEwRU3WCYwCi5gZFjF
	KJpakFxQnJReZKRXnJhbXJqXrpecn7uJERgtp/8969vBePOA9SFGAQ5GJR7eDXLrQ4RYE8uK
	K3MPMZoCbZjILCWanA+MybySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhid/rbe/VXLtPTj/z9usxdHs/EoVxjWMdkrzW68fuXRvO1TptYf5ZRV9kvc
	ku+UvGR3W3byjwnudpzK313OnlfJmJw+6UYCl1H1pK+e1poqi+qvm6ff400VnF/wbYuF++ST
	BjmdG/frW+xjO/1qLl+pVnjfat0q8ZZTi//M4eicy5mrfV76+m0lluKMREMt5qLiRAARdQKI
	kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jAV2ZqetDDJZMZ7Y4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVr0v1nIanHu1UpGi0n3J7BYvN9zhtHi8q45bBafe48wWiy9fpHJ
	YsL0tSwWrXuPsFuc3l1iMWPySzYHAY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2repk87hzbQ+b
	R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
	ufgE6Lpl5gC9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMaL8zla3g
	F2fF9qcNzA2MF9i7GDk5JARMJKbdecIIYYtJXLi3nq2LkYtDSGARo8Tcj19YIJw2Jokb73pY
	QarYBDQl3k+5wgJiiwhkSGzvmMIMUsQssIxJ4lzrIWaQhLCAg8TRpm1MIDaLgKrE+tYtYM28
	Am4SLxc+BWrmAFqnIDFnks0ERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj8Zn0
	DsZVDRaHGAU4GJV4eDfIrQ8RYk0sK67MPcQowcGsJMJ7aAJQiDclsbIqtSg/vqg0J7X4EKMp
	0PKJzFKiyfnARJFXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cAo
	cGP/vA43tg4+m/bVyqbWgR+tlpbpCT1oOxg7xTGP2e+XDletUJ2Gae/Z37vYg/qZzfPvTZQp
	SrIUiGi39E0WOrSm5VhUesclwX07l38otmusdNl6T07t8Z89fyv783+cyU16dTRre5jwbFaO
	mD2rUne0n+Rd+erkPTVLvflrLuvPENoleESJpTgj0VCLuag4EQA6uFak3AIAAA==
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

Changes in v2:
- Revise binding documentation..
 
Beomho Seo (3):
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 6 files changed, 782 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c

-- 
1.7.9.5

