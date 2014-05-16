Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaEPAsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:48:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31663 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaEPAsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:48:37 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ab-53756062fe48
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
In-reply-to: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
Subject: Re: [PATCH v1 0/5] Add Keystone PCIe controller driver
Date: Fri, 16 May 2014 09:48:34 +0900
Message-id: <004f01cf70a0$90d7e520$b287af60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9wVwStLuxIQSTKQyy3QmeKF3q0xAASBxeg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zQ92khNJgg6OrDC2WNGVYvDykaXHg
	zw5Gi8sLL7FaXHjaw2ax6fE1VovLu+awWZydd5zN4vZlXou+3gNsFm/aGhktNk79xWjRfknZ
	4vEsYYvWvUfYLV73rWF2EPBoae5h85g36wSLx7/D/UweCzaVemxa1cnmcefaHjaPzUvqPfq2
	rGL0ePpjL7PH8RvbmTw+b5IL4I7isklJzcksSy3St0vgytj8chJzwT2JiiunrrM1MHYJdTFy
	ckgImEj8nLCJEcIWk7hwbz1bFyMXh5DAMkaJ6y9essAUNS//xApiCwlMZ5S4P9Maoug3o0T/
	1mdsIAk2ATWJL18Os4PYIgI6EsuONzKBFDELLGCR+NE2lR2i20ni2fsVzCA2p4CzxLHeN0wg
	trCAvcT7C7/AtrEIqEq0758EZvMK2Eos+rafHcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b4Fm
	cgBdqi7x6K8uxA1GEhdm9zBClIhI7HvxjhHkHgmBCxwSHT0XWCF2CUh8m3yIBaJXVmLTAWaI
	hyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQI
	SSP9OxjvHrA+xJgMtH4is5Rocj4wDeWVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsbQ3ZlrtAKy5y/08dimaSZ+pqHOVZhza1aU2vOenl0GRzb0
	rKg9KJp180r89YMlJqc175X3Pr2oej9vdtHmJF2zSI66+r2PMg5dNO5Pu8X159P/otubl7CZ
	6O3SnFuiqnDE6rKpbW6fa3Rn2LNb96wDH1xxXKC/4NEKL+8NHCulf3hFiDzaaKHEUpyRaKjF
	XFScCADKJ3YYOQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xoG5SQmmwQdsubYslTRkWLw9pWhz4
	s4PR4vLCS6wWF572sFlsenyN1eLyrjlsFmfnHWezuH2Z16Kv9wCbxZu2RkaLjVN/MVq0X1K2
	eDxL2KJ17xF2i9d9a5gdBDxamnvYPObNOsHi8e9wP5PHgk2lHptWdbJ53Lm2h81j85J6j74t
	qxg9nv7Yy+xx/MZ2Jo/Pm+QCuKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MWZsfjmJueCeRMWVU9fZGhi7hLoYOTkkBEwkmpd/YoWwxSQu3FvPBmILCUxnlLg/07qLkQvI
	/s0o0b/1GViCTUBN4suXw+wgtoiAjsSy441MIEXMAgtYJH60TWWH6HaSePZ+BTOIzSngLHGs
	9w0TiC0sYC/x/sIvFhCbRUBVon3/JDCbV8BWYtG3/ewQtqDEj8n3wOLMAloS63ceZ4Kw5SU2
	r3kLNJMD6FJ1iUd/dSFuMJK4MLuHEaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnCSeia9g3FVg8UhRgEORiUe3gtapcFCrIllxZW5hxgl
	OJiVRHhP2wKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YQPNK4g2NTcyMLI3MLIxMzM1J
	E1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbFc++oC1U77fztzZPi+q8rsNxB5my317XyP
	RZfxfPGFxc1P5FLeGu1IFmO/eFT0tJEb92HFh4+erJzVvOlbuId4QrWdX3PN7eSP7mcPnlb8
	kJvELnxixU3NXY43Ju87L2Sgc/T6GkPxGcbe1Qdjbytvq3qxpW+uaoxNoZCScXD3wUUTfp5Q
	kFdiKc5INNRiLipOBABC1bGflgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 1:01 AM, Murali Karicheri wrote:
> 
> This patch adds a PCIe controller driver for Keystone SoCs. This
> is based on the origin RFC patch that I had sent earlier. I have
> incorporated following comments:-
> 
>  - Add a interrupt controller node for Legacy irq chip and use
>    interrupt map/map-mask property to map legacy IRQs A/B/C/D
>  - Add a Phy driver to replace the original serdes driver
>  - Move common applicaiton register handling code to a separate
>    file to allow re-use across other platforms that use older
>    DW PCIe h/w
>  - PCI quirk for maximum read request size. Check and override only
>    if the maximum is higher than what controller can handle.
>  - Converted to a module platform driver.
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> 

Your patches modify 'pcie-designware.c', and affects other PCIe
drivers using designware PCIe Core IP. Please add the following
people to CC list. They are also related to the designware PCIe.

  Pratyush Anand <pratyush.anand@st.com>
  Richard Zhu <r65037@freescale.com>
  Kishon Vijay Abraham I <kishon@ti.com>
  Marek Vasut <marex@denx.de>

Best regards,
Jingoo Han

> 
> Murali Karicheri (5):
>   ARM: keystone: add pcie related options
>   pci: designware: enhancements to support keystone pcie
>   phy: pci serdes phy driver for keystone
>   pci: dw: add common functions to support old hw based pci driver
>   pci: keystone: add pcie driver based on designware core driver
> 
>  .../devicetree/bindings/pci/pcie-keystone.txt      |   68 ++++
>  arch/arm/mach-keystone/Kconfig                     |    2 +
>  drivers/pci/host/Kconfig                           |   12 +
>  drivers/pci/host/Makefile                          |    2 +
>  drivers/pci/host/pci-dw-old-msi.c                  |  150 ++++++++
>  drivers/pci/host/pci-dw-old.c                      |  371 ++++++++++++++++++
>  drivers/pci/host/pci-dw-old.h                      |   30 ++
>  drivers/pci/host/pci-keystone.c                    |  400 ++++++++++++++++++++
>  drivers/pci/host/pcie-designware.c                 |  101 +++--
>  drivers/pci/host/pcie-designware.h                 |   42 +-
>  drivers/pci/quirks.c                               |   13 +
>  drivers/phy/Kconfig                                |    6 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-keystone.c                         |  230 +++++++++++
>  14 files changed, 1388 insertions(+), 40 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
>  create mode 100644 drivers/pci/host/pci-dw-old-msi.c
>  create mode 100644 drivers/pci/host/pci-dw-old.c
>  create mode 100644 drivers/pci/host/pci-dw-old.h
>  create mode 100644 drivers/pci/host/pci-keystone.c
>  create mode 100644 drivers/phy/phy-keystone.c
> 
> --
> 1.7.9.5

