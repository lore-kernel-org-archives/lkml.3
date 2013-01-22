Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3AVFXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:23:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11765 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3AVFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:23:48 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-82-50fe2263e71d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com,
        cpgs@samsung.com
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
Date: Mon, 21 Jan 2013 21:23:28 -0800
Message-id: <053c01cdf860$9e98df20$dbca9d60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJl+CDGWU+ThpKKeozp1tuXzSNA+pckz+BA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd1kpX8BBjd7pCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgypg74xRTwSfBij+N11gbGOfzdjFyckgImEhs
	mHWEBcIWk7hwbz1bFyMXh5DAMkaJZ/fuMcEULX5/mhEisYhR4te35ywQzl9GiT+zV7ODVLEJ
	aEgcfv8MzBYR8JC4e2w5O0gRs8BtJonpd7eD7RACSiycuIoVxOYU8JRYv2kmI4gtDGTfX7YH
	bB2LgKrEyTNLweK8ApYSR1ZvYYOwBSV+TL4HNodZQEti87YmVghbXmLzmrfMEKcqSOw4+5oR
	4ggjiTUPd7FB1IhLTHrwEOwgCYFN7BLT3i1mhVgmIPFt8iGgoRxACVmJTQeg5khKHFxxg2UC
	o8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kREnNSOxhXNlgc
	YhTgYFTi4bV49DdAiDWxrLgy9xCjBAezkghv/z+gEG9KYmVValF+fFFpTmrxIcZkoGMnMkuJ
	JucD00FeSbyhsbGJmYmpibmlqbkpacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamBklkni
	+Wys3c/3YFu3Cb/A1ZUXl4eJ6P49W/fo7Pf2/2VzfwgfDn64bW5AXsBOJ68bpw+xBHyJ8HPl
	XdDh+j+dN2zJsWeFKgzBO3yC3ty5nq2f/oYtiWHuLwvFDdNVVS/M4Lu4R7Jpa8a+zNwpzjZS
	suvP6ZdZL14Wd+CP7QcH7XyjPW3Z/hlKLMUZiYZazEXFiQDxQTR//QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd1kpX8BBg/Xilhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5gxd8Yp
	poJPghV/Gq+xNjDO5+1i5OSQEDCRWPz+NCOELSZx4d56ti5GLg4hgUWMEr++PWeBcP4ySvyZ
	vZodpIpNQEPi8PtnYLaIgIfE3WPL2UGKmAVuM0lMv7udBSQhBJRYOHEVK4jNKeApsX7TTLAV
	wkD2/WV7mEBsFgFViZNnloLFeQUsJY6s3sIGYQtK/Jh8D2wOs4CWxOZtTawQtrzE5jVvmSFO
	VZDYcfY1I8QRRhJrHu5ig6gRl5j04CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERzRz6R2MK5ssDjEKMDBqMTDa/Hob4AQa2JZcWXuIUYJDmYlEd7+
	f0Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmm7ySeENjEzMjSyMzCyMTc3PShJXEeRlP
	PQkQEkhPLEnNTk0tSC2C2cLEwSnVwNiep3TemttPImuy3KJbhnknJjyy8+js3b7hTTjfgb/S
	97//nWuW/HnP9Le9RfFP/hzkSfB6MmG1R9/VB1XRF34t0q5U6nQorVjodO68zdW9s+6v2Ra1
	0O7VwZQ+dhmFwnDJaXfsjHiE3AO/RO3iX8grNZkrISVxf175hz1JKmd+VFdIearNTlBiKc5I
	NNRiLipOBADtsXx5LAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Changes from v5:
>  - Rebased on top of latest patches:
>         usb: phy: samsung: Introducing usb phy driver for hsotg (v9)
>         usb: phy: samsung: Add support to set pmu isolation (v6)
>    As a result adding hostphy enable mask and hostphy register offsets
>    to driver data in order to access the HOSTPHY CONTROL register.
> 
>  - Adding member 'otg' to struct samsung-usbphy so that its consumers
>    can call otg->set_host so as to make 'phy' aware of the consumer type:
> 	HOST/DEVICE
> 
>  - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
>    which keeps track of 'otg' of the controllers' phy. This then sets
>    the host.
> 
>  - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exynos
>    to phy driver itself where based on phy_type it is called.
> 
>  - Added separate macro definition for USB20PHY_CFG register to select
>    between host/device type usb link.
> 
>  - Removing unnecessary argument 'phy_type' from
> samsung_usbphy_set_type()
>    and samsung_usbphy_cfg_sel().
> 
>  - Addressed few nits:
> 	-- added macro for 'KHZ'
> 	-- removing useless 'if' from samsung_usbphy_cfg_sel()
> 	-- keeping the place of clk_get intact and requesting driver
> 	   data before that.
> 
> Vivek Gautam (4):
>   ARM: EXYNOS: Update & move usb-phy types to generic include layer
>   usb: phy: samsung: Add host phy support to samsung-phy driver
>   USB: ehci-s5p: Add phy driver support
>   USB: ohci-exynos: Add phy driver support
> 
>  .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
>  drivers/usb/host/ehci-s5p.c                        |   81 +++-
>  drivers/usb/host/ohci-exynos.c                     |   85 +++-
>  drivers/usb/phy/Kconfig                            |    2 +-
>  drivers/usb/phy/samsung-usbphy.c                   |  512
++++++++++++++++++--
>  include/linux/usb/samsung_usb_phy.h                |   16 +
>  6 files changed, 635 insertions(+), 73 deletions(-)
>  create mode 100644 include/linux/usb/samsung_usb_phy.h
> 
> --
> 1.7.6.5

Looks good to me,

Felipe and Greg, I don't know who should take this series anyway, feel free
to add  my ack:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

