Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3IZEcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:32:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47533 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3IZEcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:32:20 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-89-5243b8d39f27
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com>
In-reply-to: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com>
Subject: Re: [PATCH V3] PCI: exynos: add support for MSI
Date: Thu, 26 Sep 2013 13:32:18 +0900
Message-id: <001b01ceba71$62ca02c0$285e0840$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qzgD9S8HY2ygfQryi1L0um5BFGQPot8ww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zQ93LO5yDDDr3KFj8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRnHZpKTmZJalFunbJXBl/P2/m7Ggl7uiZ/cFtgbGVs4uRk4O
	CQETie5b61khbDGJC/fWs3UxcnEICSxjlLje+psRpujR2xZ2EFtIYDqjxO1J8hBFvxglzp57
	wwySYBNQk/jy5TBYkYiApsTsFVuYQIqYBe6xSPQfXsAK0W0rceL4BbAiTgE7iVM/J7GA2MIC
	FhKtc78zgdgsAqoSEy4/BBvKC1T/oHM7K4QtKPFj8j2wemYBLYn1O48zQdjyEpvXvAWq5wC6
	VF3i0V9diBuMJN6s38oMUSIise/FO0aQeyQEznBIbJ+4lw1il4DEt8mHWCB6ZSU2HWCGeFhS
	4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkBTS
	v4Px7gHrQ4zJQOsnMkuJJucDU1BeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhhTXbfJcnv2OLvtcdQKcwr/9ejP9iqx02f/PXVf7rewfH3p05oS
	+4l3bCcv/rJSN2reBPuvWSdiLzhVRIQU5D7akcdZvGlmJ/ul8wnHfD2PCXO5lGW/CUzrk4yx
	3HGme/l/i4b6iaKfNmnu0pB39RPNNm+pnOf05U5zYfCUh292Gl+cvdBuVagSS3FGoqEWc1Fx
	IgCPjD5MNwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoO7lHc5BBsv2Sln8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zPj7fzdjQS93Rc/uC2wNjK2cXYycHBICJhKP3rawQ9hiEhfurWcDsYUEpjNK3J4k38XIBWT/
	YpQ4e+4NM0iCTUBN4suXw2ANIgKaErNXbGECKWIWuMci0X94AStEt63EieMXwIo4BewkTv2c
	xAJiCwtYSLTO/c4EYrMIqEpMuPwQbCgvUP2Dzu2sELagxI/J98DqmQW0JNbvPM4EYctLbF7z
	FqieA+hSdYlHf3UhbjCSeLN+KzNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzgBPVMagfjygaLQ4wCHIxKPLwXmJ2DhFgTy4orcw8xSnAw
	K4nwfjMCCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MHnmlcQbGpuYGVkamVkYmZibkyas
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjwtmji5zZIm7nOH55x+RSXmR3Ki+5bd0bga06
	B+5O4lp/NmbLhROSFXP4Wp9P0zyeLBVW4PVPX8NRUZChZOu1Ry6PJev6FW4J55lsUnC6obZ0
	kUvluw1zbmToX8xTTyu/e4pLL+lC7X/uvXIvfVM3pIj/XWxV5ZxY5xFye/+npjlyCmoz4uqV
	WIozEg21mIuKEwF8ZdpMlAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 3:55 PM, Jingoo Han wrote:
> 
> This patch adds support for Message Signaled Interrupt in the
> Exynos PCIe diver using Synopsys designware PCIe core IP.
> 
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>

Hi Bjorn Helgaas,

There is no comment for last 3 weeks.
Would you merge this patch to your tree?
Thank you.

Best regards,
Jingoo Han

> ---
> Changes since v2:
> - fixed MAX_MSI_CTRLS because MAX_MSI_IRQS is 32 only
> - used __get_free_pages() to allocate msi_data
> - used one msi_data and msi_irq_in_use per one RC
> - used irq_domain to represent the MSI controller
> - removed msi-base irq number from device tree because this is not
>   a hardware property.
> 
> Changes since v1:
> - removed unnecessary exynos_pcie_clear_irq_level()
> - updated the bindings documentation
> - used new msi_chip infrastructure
> - removed ARCH_SUPPORTS_MSI
> - replaced #ifdef guards with IS_ENABLED(CONFIG_PCI_MSI)
> 
>  drivers/pci/host/pci-exynos.c      |   44 +++++++
>  drivers/pci/host/pcie-designware.c |  240 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/host/pcie-designware.h |   14 +++
>  3 files changed, 298 insertions(+)

