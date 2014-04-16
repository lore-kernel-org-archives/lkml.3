Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaDPEl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:41:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaDPElz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:41:55 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d0-534e0a11c5b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [RFC PATCH 0/2] Add support for Samsung GH7 PCIe controller
Date: Wed, 16 Apr 2014 13:41:53 +0900
Message-id: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZLjB5lnZMYwshRiWF5lDNQlfulQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zQ11BLr9gg98vbCz+TjrGbrGkKcPi
	8sJLrBa9C66yWbw/9IzZYtPja6wWl3fNYbM4O+84m8WBpe0sDpwea+atYfT4/WsSo8eCTaUe
	m5fUe9z+95jZo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDJu/H3PUvCAreLU83+MDYx7WLsY
	OTkkBEwkmnYsYIOwxSQu3FsPZHNxCAksY5S417qCBabo1YRTTBCJ6YwSC//MYYZwfjNK3P21
	DKyKTUBN4suXw+wgtohAiMTvu7fBRjEL/GGU2HnyHlAHB4ewgItE5zIDEJNFQFVizUIlkHJe
	AVuJrhcfmSBsQYkfk++BjWQW0JJYv/M4E4QtL7F5zVuwKRIC6hKP/upCbNKTePFjByNEiYjE
	vhfvGEG2Sgi8ZZfYsGwV2DksAgIS3yYfYoHolZXYdIAZ4i9JiYMrbrBMYBSbhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQuK1dwfj7QPWhxiTgdZPZJYSTc4H
	xnteSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAG
	eMwIfl3BkZaZFFr3wzE471BkzKmAT8/niHrudrIRLLK2zNeXFjj28Z10Kr+y+5JzU1lcchdf
	Xck2v/qcrOC2dynsM3a3Vp6OSNV0CZ57fPqxX5nz9xSmLPituTlpn0NxY2zfHq1LO8OKS8KX
	ZCbZprjkurhtZNimtebiCdfAd8znNJv6LiqxFGckGmoxFxUnAgDfAZht7QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQV1BLr9gg6btFhZ/Jx1jt1jSlGFx
	eeElVoveBVfZLN4fesZssenxNVaLy7vmsFmcnXeczeLA0nYWB06PNfPWMHr8/jWJ0WPBplKP
	zUvqPW7/e8zs0bdlFaPH501yAexRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	6xgzbvx9z1LwgK3i1PN/jA2Me1i7GDk5JARMJF5NOMUEYYtJXLi3nq2LkYtDSGA6o8TCP3OY
	IZzfjBJ3fy1jAaliE1CT+PLlMDuILSIQIvH77m2wDmaBP4wSO0/eA+rg4BAWcJHoXGYAYrII
	qEqsWagEUs4rYCvR9eIjE4QtKPFj8j2wkcwCWhLrdx5ngrDlJTaveQs2RUJAXeLRX12ITXoS
	L37sYIQoEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iRGcDJ5J72Bc1WBxiFGAg1GJh3dmjm+wEGtiWXFl7iFGCQ5mJRHeL1+AQrwpiZVVqUX5
	8UWlOanFhxiTgf6cyCwlmpwPTFR5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5N
	LUgtgtnCxMEp1cA4q9SZdeFcoav2txsi2cNSObSbqvgXctVLldp0i/nx7d/RuJOXyU/JdPKf
	PY0Nh2atnmTQf1JndZsh+2FThfAaadHg6bPYb3uYRr/f/ONkw/PIhgzO59dDJ05cW/siZ/Ny
	w1mvN2y0jGHn/f4zTFlrtl+vIH/pl+tr7/yOfvNt59U/L7IsBNyVWIozEg21mIuKEwE7h6jr
	SgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Samsung GH7 PCIe host controller.
Samsung GH7 PCIe controller driver has dependency on the PCI arm64
arch support. So, the Liviu Dudau's patcheset for creating generic
host_bridge from device tree [1] and supporting PCI in AArch64 [2]
are required.

This patch is marked as RFC, so any comment will be welcomed.
Thank you.

[1] http://www.spinics.net/lists/linux-pci/msg29786.html
[2] http://www.spinics.net/lists/linux-pci/msg29793.html

Jingoo Han (2)
  PCI: designware: Add ARM64 PCI support
  PCI: exynos: Add PCIe support for Samsung GH7 SoC

---
 drivers/pci/host/Kconfig           |    2 +-
 drivers/pci/host/pci-exynos.c      |  135 +++++++++++++++++++++++++++++++++---
 drivers/pci/host/pcie-designware.c |   32 +++++++++
 3 files changed, 158 insertions(+), 11 deletions(-)

Best regards,
Jingoo Han

