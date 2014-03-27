Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaC0DoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:44:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59027 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaC0DoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:44:10 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-45-53339e6e9865
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, mohit.kumar@st.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        paul@pwsan.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
 <1395842272-15267-3-git-send-email-kishon@ti.com>
In-reply-to: <1395842272-15267-3-git-send-email-kishon@ti.com>
Subject: Re: [RFC PATCH 02/12] pci: host: pcie-dra7xx: add support for
 pcie-dra7xx controller
Date: Thu, 27 Mar 2014 12:43:41 +0900
Message-id: <000c01cf496e$bf2c85b0$3d859110$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9I+5TziCsFjnYJQ8SyLv8x0Jb4XQAaKfqg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t8zY928ecbBBqu3i1osacqweHlI02L+
	kXOsFv1vFrJanHu1ktHi8sJLrBYXnvawWWx6fI3VYmHbEhaLy7vmsFnMXtLPYnF23nE2i9uX
	eS2WXr/IZLFx6i9Giw87/jJbTJi+lsXiWf8eRot1L6ezWLTuPcJusf+Kl4Oox5p5axg9Wpp7
	2Dy+fZ3E4nG5r5fJY8GmUo+Vy7+weWxa1cnm8Wr1TFaPzUvqPW787mX36NuyitHj6Y+9zB7H
	b2xn8vi8SS6AL4rLJiU1J7MstUjfLoErY+eb2UwFUwQrrvd0sDUwnubtYuTkkBAwkZjz9j4z
	hC0mceHeerYuRi4OIYFljBJfuu8ywxSd7jzMCJGYzijxse8cC4Tzm1Hi7fzT7CBVbAJqEl++
	HAazRQR0JBaeXs8MUsQscItZoufkeVaQhJBAocTq22fAxnIK2Ek8b1zBCGILC8RL3Jv8iAnE
	ZhFQlZh/4RFYDa+ArcTHd9fZIGxBiR+T77GA2MwCWhLrdx5ngrDlJTaveQtUzwF0qrrEo7+6
	EDcYSTybsp0RokREYt+Ld2AfSAhM5pR49uEfI8QuAYlvkw+xQPTKSmw6APWxpMTBFTdYJjBK
	zEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCGpqXcH4+0D1ocY
	k4HWT2SWEk3OB6a2vJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgfBBYnhwdv7vGw/ji44QMmZuiwVd0fXcpXLHsZrTqZ31pPONEmmqy50SuCzsO
	JPObp56V6Gu22Je4JOKuEOv8gjfiF/7/v9/nsrpfafJj4SnHK2cYcr0wn2Z27s80LbPV+euL
	PdR3MBzuvOfIu6ZO7/bDYze6UxuaPhS/MubP+XSkpszmww0GJZbijERDLeai4kQAl2oeD2MD	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsVy+t9jQd28ecbBBpuu8lksacqweHlI02L+
	kXOsFv1vFrJanHu1ktHi8sJLrBYXnvawWWx6fI3VYmHbEhaLy7vmsFnMXtLPYnF23nE2i9uX
	eS2WXr/IZLFx6i9Giw87/jJbTJi+lsXiWf8eRot1L6ezWLTuPcJusf+Kl4Oox5p5axg9Wpp7
	2Dy+fZ3E4nG5r5fJY8GmUo+Vy7+weWxa1cnm8Wr1TFaPzUvqPW787mX36NuyitHj6Y+9zB7H
	b2xn8vi8SS6AL6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6GklhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bON7OZCqYI
	Vlzv6WBrYDzN28XIySEhYCJxuvMwI4QtJnHh3nq2LkYuDiGB6YwSH/vOsUA4vxkl3s4/zQ5S
	xSagJvHly2EwW0RAR2Lh6fXMIEXMAreYJXpOnmcFSQgJFEqsvn2GGcTmFLCTeN64AmyFsEC8
	xL3Jj5hAbBYBVYn5Fx6B1fAK2Ep8fHedDcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrdA9RxA
	p6pLPPqrC3GDkcSzKdsZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBCe+Z1I7GFc2WBxiFOBgVOLh3XHfKFiINbGsuDL3EKMEB7OSCO/p
	LuNgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJuW8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tFoHCgmkJ5akZqemFqQWwWxh4uCUamBU2muQe44zcM3M3U6FfqYfNeaZ9WtH/K2ZP9NlrRVL
	8obVa+6U/zxyLWppfj2PsntJU/0B06VNlrvK3jY9nv7iqGFFxVNdv9cJVVw/YmtPtHOeuRpy
	z7H227w7D69aXU/nc22dxsO379aaP9Lvbn1xNXhy9kXYvuK2aSLVJj2306bdvnPS5oe/Ektx
	RqKhFnNRcSIApp9FjsADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 26, 2014 10:58 PM, Kishon Vijay Abraham I wrote:
> 
> Added support for pcie controller in dra7xx. This driver re-uses
> the designware core code that is already present in kernel.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Hi Kishon,
Long time no see! I added trivial comments.

> ---
>  Documentation/devicetree/bindings/pci/ti-pci.txt |   35 ++
>  drivers/pci/host/Kconfig                         |   10 +
>  drivers/pci/host/Makefile                        |    1 +
>  drivers/pci/host/pcie-dra7xx.c                   |  411 ++++++++++++++++++++++

How about using 'pci-' prefix?
As it was discussed earlier, 'pci-' prefix is more proper.

>  4 files changed, 457 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>  create mode 100644 drivers/pci/host/pcie-dra7xx.c

[.....]

> --- /dev/null
> +++ b/drivers/pci/host/pcie-dra7xx.c

[.....]

> +#define	PCIECTRL_TI_CONF_IRQSTATUS_MAIN		0x0024
> +#define	PCIECTRL_TI_CONF_IRQENABLE_SET_MAIN	0x0028

I don't think that it's good to add vendor names such as TI
to SFR names.

How about adding 'DRA7XX' or just removing 'TI'?

1. PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN

2. PCIECTRL_CONF_IRQSTATUS_MAIN

[.....]

> +enum dra7xx_pcie_device_type {
> +	DRA7XX_PCIE_UNKNOWN_TYPE,
> +	DRA7XX_PCIE_EP_TYPE,
> +	DRA7XX_PCIE_LEG_EP_TYPE,
> +	DRA7XX_PCIE_RC_TYPE,
> +};

This driver can support only RC mode, so, these enum can be removed.

[.....]

> +	of_property_read_u32(node, "ti,device-type", &device_type);
> +	switch (device_type) {
> +	case DRA7XX_PCIE_RC_TYPE:
> +		dra7xx_pcie_writel(dra7xx->base,
> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_RC);
> +		break;
> +	case DRA7XX_PCIE_EP_TYPE:
> +		dra7xx_pcie_writel(dra7xx->base,
> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_EP);
> +		break;
> +	case DRA7XX_PCIE_LEG_EP_TYPE:
> +		dra7xx_pcie_writel(dra7xx->base,
> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_LEG_EP);
> +		break;
> +	default:
> +		dev_dbg(dev, "UNKNOWN device type %d\n", device_type);
> +	}

Thus, this switch can be removed.
Others look good.

Best regards,
Jingoo Han

