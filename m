Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaC0LpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:45:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38054 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaC0LpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:45:04 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-a0-53340f3ebd0b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        tony@atomide.com, rnayak@ti.com, paul@pwsan.com,
        "'Marek Vasut'" <marex@denx.de>,
        "'Richard Zhu'" <r65037@freescale.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
 <1395842272-15267-4-git-send-email-kishon@ti.com>
In-reply-to: <1395842272-15267-4-git-send-email-kishon@ti.com>
Subject: Re: [RFC PATCH 03/12] pci: host: pcie-designware: Use *base-mask* for
 configuring the iATU
Date: Thu, 27 Mar 2014 20:45:01 +0900
Message-id: <000001cf49b1$fcd8a810$f689f830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9I+4kHfk49qKvMS7SN4ZGGUMaHhAAta6iw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t8zA107fpNgg7Pr+S2WNGVYvDykaTH/
	yDlWi/43C1ktzr1ayWhx4WkPm8Wmx9dYLRa2LWGxuLxrDpvF7CX9LBZn5x1ns7h9mdfiTVsj
	o8XS6xeZLDZO/cVo8WHHX2aLCdPXsli0X1K2eDxL2OJZ/x5Gi3Uvp7NYtO49wm6x/4qXg7jH
	mnlrGD1amnvYPL59ncTicbmvl8lj3qwTLB7/DvczeSzYVOqxcvkXNo9NqzrZPF6tnsnqsXlJ
	vceN373sHn1bVjF6PP2xl9nj+I3tTB6fN8kFCERx2aSk5mSWpRbp2yVwZUxuFy2YZ14x9/oj
	5gbGRXpdjJwcEgImEq83/WaDsMUkLtxbD2RzcQgJLGOUmHjnPzNM0ZppZ6ASixglTj17xw7h
	/GaUuPryCztIFZuAmsSXL4fBbBGBGolLM/YygxQxCzxnlrj7tRtslJBAocS3i8eZQGxOATuJ
	vRu+MoLYwgKpEkcW3WEBsVkEVCUWnj0CdhOvgK3Ent5rzBC2oMSPyffAapgFtCTW74SYwywg
	L7F5zVugGg6gU9UlHv3VBTFFBIwkLh1zgqgQkdj34h0jyDkSAss5JTatOcEOsUpA4tvkQywQ
	rbISmw5APSwpcXDFDZYJjBKzkCyehWTxLCSLZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66
	XnJ+7iZGSOqauIPx/gHrQ4zJQOsnMkuJJucDU19eSbyhsZmRhamJqbGRuaUZacJK4rzpj5KC
	hATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqXq38++eRhqddx/9VASVeEoteiG/Zm67GYzBr
	VqWUnftEtm/N1bFnX732VbdNnBwxi0G0wVh0W273/r3tiZmX5i8tCntr8DzrwjY+9sya14ZR
	SVtO3jqu4njJ0vptYlu6itKXb476/13tNrJaqZc3B0sda//Ko6bBdVumcXXqi19Od/OYdymx
	FGckGmoxFxUnAgAYGgYKcwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsVy+t9jAV07fpNgg8td7BZLmjIsXh7StJh/
	5ByrRf+bhawW516tZLS48LSHzWLT42usFgvblrBYXN41h81i9pJ+Fouz846zWdy+zGvxpq2R
	0WLp9YtMFhun/mK0+LDjL7PFhOlrWSzaLylbPJ4lbPGsfw+jxbqX01ksWvceYbfYf8XLQdxj
	zbw1jB4tzT1sHt++TmLxuNzXy+Qxb9YJFo9/h/uZPBZsKvVYufwLm8emVZ1sHq9Wz2T12Lyk
	3uPG7152j74tqxg9nv7Yy+xx/MZ2Jo/Pm+QCBKIaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgMGgpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY3C5aMM+8Yu71R8wNjIv0uhg5OSQETCTWTDvDBmGLSVy4tx7I5uIQEljE
	KHHq2Tt2COc3o8TVl1/YQarYBNQkvnw5DGaLCNRIXJqxlxmkiFngObPE3a/dzCAJIYFCiW8X
	jzOB2JwCdhJ7N3xlBLGFBVIljiy6wwJiswioSiw8ewRsNa+ArcSe3mvMELagxI/J98BqmAW0
	JNbvhJjDLCAvsXnNW6AaDqBT1SUe/dUFMUUEjCQuHXOCqBCR2PfiHeMERqFZSAbNQjJoFpJB
	s5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnBifSe9gXNVgcYhRgINRiYd3x32j
	YCHWxLLiytxDjBIczEoivI+4TYKFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YtPNK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVF608r0rtcGwDR46p0y
	i+dShYy/XFFOLnv+8Ew8nr+MdTXXikmvVvjrMOcKW5bpC/luOvKCIzfAauWGtb96PLk2Z99L
	PMbwpLaTvXNGm8kmbps2vp2NJ3wOFgtfuBIXoqK75t2c/pfdOzQnKxc8VP5ds1xpSrf7+pOC
	3ByXPjL98yibe2A7pxJLcUaioRZzUXEiAEOvpiTQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 26, 2014 10:58 PM, Kishon Vijay Abraham I wrote:
> 
> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> address. So whenever the cpu issues a read/write request, the 4 most
> significant bits are used by L3 to determine the target controller.
> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> the outbound translation window the *base* should be programmed as 0x000_0000.
> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> we have programmed in the translation window with base as 0x000_0000.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

(+cc Pratyush Anand, Marek Vasut, Richard Zhu)

Acked-by: Jingoo Han <jg1.han@samsung.com>

Mohit Kumar, Pratyush Anand,
If you have other opinions, please let us know. :-)
Thank you.

Best regards,
Jingoo Han

> ---
>  .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>  drivers/pci/host/pcie-designware.c                 |   39 ++++++++++++++------
>  drivers/pci/host/pcie-designware.h                 |    1 +
>  3 files changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> index d6fae13..c574dd3 100644
> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> @@ -27,6 +27,7 @@ Optional properties for fsl,imx6q-pcie
>  - power-on-gpio: gpio pin number of power-enable signal
>  - wake-up-gpio: gpio pin number of incoming wakeup signal
>  - disable-gpio: gpio pin number of outgoing rfkill/endpoint disable signal
> +- base-mask: address mask for the PCIe controller target port
> 
>  Example:
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 17ce88f..98b661c 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -464,6 +464,9 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  		return -EINVAL;
>  	}
> 
> +	if (of_property_read_u64(np, "base-mask", &pp->base_mask))
> +		pp->base_mask = ~(0x0ULL);
> +
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>  		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
>  					MAX_MSI_IRQS, &msi_domain_ops,
> @@ -503,12 +506,15 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> 
>  static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
>  {
> +	u64 cfg0_base;
> +
> +	cfg0_base = pp->cfg0_base & pp->base_mask;
>  	/* Program viewport 0 : OUTBOUND : CFG0 */
>  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
>  			  PCIE_ATU_VIEWPORT);
> -	dw_pcie_writel_rc(pp, pp->cfg0_base, PCIE_ATU_LOWER_BASE);
> -	dw_pcie_writel_rc(pp, (pp->cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
> -	dw_pcie_writel_rc(pp, pp->cfg0_base + pp->config.cfg0_size - 1,
> +	dw_pcie_writel_rc(pp, cfg0_base, PCIE_ATU_LOWER_BASE);
> +	dw_pcie_writel_rc(pp, (cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
> +	dw_pcie_writel_rc(pp, cfg0_base + pp->config.cfg0_size - 1,
>  			  PCIE_ATU_LIMIT);
>  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
>  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
> @@ -518,14 +524,17 @@ static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> 
>  static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
>  {
> +	u64 cfg1_base;
> +
> +	cfg1_base = pp->cfg1_base & pp->base_mask;
>  	/* Program viewport 1 : OUTBOUND : CFG1 */
>  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
>  			  PCIE_ATU_VIEWPORT);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> -	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
> -	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
> -	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
> +	dw_pcie_writel_rc(pp, cfg1_base, PCIE_ATU_LOWER_BASE);
> +	dw_pcie_writel_rc(pp, (cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
> +	dw_pcie_writel_rc(pp, cfg1_base + pp->config.cfg1_size - 1,
>  			  PCIE_ATU_LIMIT);
>  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
>  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
> @@ -533,14 +542,17 @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
> 
>  static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
>  {
> +	u64 mem_base;
> +
> +	mem_base = pp->mem_base & pp->base_mask;
>  	/* Program viewport 0 : OUTBOUND : MEM */
>  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
>  			  PCIE_ATU_VIEWPORT);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> -	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
> -	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
> -	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
> +	dw_pcie_writel_rc(pp, mem_base, PCIE_ATU_LOWER_BASE);
> +	dw_pcie_writel_rc(pp, (mem_base >> 32), PCIE_ATU_UPPER_BASE);
> +	dw_pcie_writel_rc(pp, mem_base + pp->config.mem_size - 1,
>  			  PCIE_ATU_LIMIT);
>  	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
>  	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
> @@ -549,14 +561,17 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
> 
>  static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
>  {
> +	u64 io_base;
> +
> +	io_base = pp->io_base & pp->base_mask;
>  	/* Program viewport 1 : OUTBOUND : IO */
>  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
>  			  PCIE_ATU_VIEWPORT);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
>  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> -	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
> -	dw_pcie_writel_rc(pp, (pp->io_base >> 32), PCIE_ATU_UPPER_BASE);
> -	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
> +	dw_pcie_writel_rc(pp, io_base, PCIE_ATU_LOWER_BASE);
> +	dw_pcie_writel_rc(pp, (io_base >> 32), PCIE_ATU_UPPER_BASE);
> +	dw_pcie_writel_rc(pp, io_base + pp->config.io_size - 1,
>  			  PCIE_ATU_LIMIT);
>  	dw_pcie_writel_rc(pp, pp->config.io_bus_addr, PCIE_ATU_LOWER_TARGET);
>  	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 3063b35..3fa12a6 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -35,6 +35,7 @@ struct pcie_port {
>  	struct device		*dev;
>  	u8			root_bus_nr;
>  	void __iomem		*dbi_base;
> +	u64			base_mask;
>  	u64			cfg0_base;
>  	void __iomem		*va_cfg0_base;
>  	u64			cfg1_base;
> --
> 1.7.9.5

