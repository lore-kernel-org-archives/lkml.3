Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3GWImb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:42:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38531 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3GWIm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:42:26 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-5e-51ee41f073e7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
 <51ED49D6.9050209@ti.com> <000701ce8741$fe47deb0$fad79c10$@samsung.com>
 <51EE22DF.6090902@ti.com>
In-reply-to: <51EE22DF.6090902@ti.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Tue, 23 Jul 2013 17:42:23 +0900
Message-id: <001401ce8780$8d8461f0$a88d25d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF5ucZjSP0iPtUWKEGMfOteg1KPqQMXV7PgAhAjdfUBwQ7mcZnkQJFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t8zY90Pju8CDRbuk7X4O+kYu8WSpgyL
	l4c0LeYfOcdqcXnhJVaL3gVX2SwuPO1hs7i8aw6bxdl5x9ksZpzfx2SxceovRov2S8oWP3fN
	Y7FoPPqA1aL1yQNGB36P378mMXrsnHWX3WPBplKP7wvns3v0bVnF6PH0x15mj+M3tjN5fN4k
	F8ARxWWTkpqTWZZapG+XwJUx4e9e5oJJChXX3p9jbmBslupi5OCQEDCR6Fio0sXICWSKSVy4
	t56ti5GLQ0hgGaPEk7t7WCASJhLND96wQyQWMUr0b73IAuH8YpToWfADrIpNQE3iy5fD7CC2
	iICOxMLT65lBipgFXjFLdH07BzV3PqPEof/9bCBVnEAdX79/ZQaxhQUSJea+/gBmswioSkw4
	s5wRxOYVsJTo3TgDyhaU+DH5Htg2ZgEtifU7jzNB2PISm9e8ZYa4VUFix9nXjBBXuEmsfjOJ
	EaJGRGLfi3eMIEdICOzgkOi51sQEsUxA4tvkQyyQwJCV2HQAao6kxMEVN1gmMErMQrJ6FpLV
	s5CsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIYliwg7GewesDzEmA62fyCwl
	mpwPTDR5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amB07e9X7dumlGPh9GXe8bNnPb9s3jHxAOOcdaESV0vbL81VzX1Te3FCeeKvLIbVxave7Jlj
	+4bryBvvFYLRWtGydaoz6nldxf/tXnwqefbtiQH8Cf0Par2WVtd8N1uwePbG5ZJN3eqMbwxS
	cxM3zW4taNOtbz959lFn7/NlbFnnj9Xs8JMI2aWqxFKckWioxVxUnAgAH7amJioDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAd0Pju8CDU53iFv8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLn7vm
	sVg0Hn3AatH65AGjA7/H71+TGD12zrrL7rFgU6nH94Xz2T36tqxi9Hj6Yy+zx/Eb25k8Pm+S
	C+CIamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6
	XUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMeHvXuaCSQoV196fY25g
	bJbqYuTkkBAwkWh+8IYdwhaTuHBvPVsXIxeHkMAiRon+rRdZIJxfjBI9C36wgFSxCahJfPly
	GKxDREBHYuHp9cwgRcwCr5glur6dg2qfzyhx6H8/G0gVJ1DH1+9fmUFsYYFEibmvP4DZLAKq
	EhPOLGcEsXkFLCV6N86AsgUlfky+B7aNWUBLYv3O40wQtrzE5jVvmSFuVZDYcfY1I8QVbhKr
	30xihKgRkdj34h3jBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJEZyInkntYFzZYHGIUYCDUYmH18P7baAQa2JZcWXuIUYJDmYlEd6lUu8ChXhTEiurUovy
	44tKc1KLDzEmA306kVlKNDkfmCTzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2a
	WpBaBLOFiYNTqoFx84Y3dxym2iTdkt4j9CIrx1+p89kk4fXFTc/rChOupnGfOqCQGtnDIinm
	abd41RyTlOI/We29TYp1unu+x3vteBx8puHSVIsP7P/SrOonFq30VmhVU36c/v5JgeWj/fv8
	r1UU8/4RWKBzlWPZjoTj/YtX9Zm8qj+kPj2w1/jWq/YdKy1ex75SYinOSDTUYi4qTgQA/SJG
	e4gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 3:30 PM, Kishon Vijay Abraham I wrote:
> On Tuesday 23 July 2013 06:44 AM, Jingoo Han wrote:
> > On Tuesday, July 23, 2013 12:04 AM, Kishon Vijay Abraham I wrote:
> >> On Thursday 18 July 2013 10:51 AM, Jingoo Han wrote:
> >>> Exynos PCIe IP consists of Synopsys specific part and Exynos
> >>> specific part. Only core block is a Synopsys designware part;
> >>> other parts are Exynos specific.
> >>> Also, the Synopsys designware part can be shared with other
> >>> platforms; thus, it can be split two parts such as Synopsys
> >>> designware part and Exynos specific part.
> >>
> >> some more queries and comments..
> >
> .
> .
> <snip>
> .
> .
> >>> +			of_pci_range_to_resource(&range, np, &pp->cfg);
> >>> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> >>> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> >>> +				resource_size(&pp->cfg));

[.....]

> >
> >> Why should it be same as dbi_base?
> >> AFAIK, jacinto6 has a dedicated configuration/io/memory space that is entirely
> >> different from dbi_base.
> >
> > According to the Synopsys designware PCIe datasheet,
> > in chapter 5.1.1 Register Space Layout,
> > 'Port Logic Registers' are placed between (config space 0x0 + 0x700)
> > and (config space 0x0 + 0xFFF).
> > 'dbi_base' is used for reading/writing 'Port Logic Registers'.
> > Exynos are using 'dbi_base' like this. Thus, the base addresses of
> > both 'dbi_base' and configuration/io/memory space are same.
> >
> > Just now, I looked at Spear PCIe driver.
> > However, in the case of Spear, the base address of configuration/io/memory
> > space is defined as 0x80000000. The base address of 'Port Logic Registers'
> > is defined as 0xb1000000.
> > I think that the situation of 'jacinto6' is similar with Spear, right?
> >
> > Then, I will move pp->dbi_base mapping code from pcie-designware.c
> > to pci-exynos.c.
> 
> I think you need not move this to exynos (since registers in dbi_base is common
> for all platforms) but modify the pcie-designware.c to use different address
> space for dbi_base. In your case, you'll duplicate the address space for
> dbi_base and configuration space.
> 

I will map 'pp->dbi_base' as below:
Also, I referenced SPEAr PCIe patches made by Pratyush Anand.
(http://permalink.gmane.org/gmane.linux.kernel.pci/18400)
(http://permalink.gmane.org/gmane.linux.kernel.pci/18403)


1. The different addresses between dbi_base and configuration space
    : SPEAr PCIe, OMAP PCIe
      'pp->dbi_base' value is come from DT binding, then, 'pp->dbi_base' will
       be mapped in spear_pcie_probe() in pci-spear.c

(arch/arm/boot/dts/spear13xx.dtsi)
		pcie0@b1000000 {
			reg = <0xb1000000 0x2000      <-- dbi register
				 0xb1002000 0x7fdfff   <-- elbi register

(drivers/pci/host/pci-spear.c)
static int __init spear_pcie_probe(struct platform_device *pdev)
{
	struct resource *dbi_base;
	struct resource *elbi_base;

	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	pp->dbi_base = devm_ioremap_resource(&pdev->dev, dbi_base);

	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
	spear_pcie->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);



2. The same addresses between dbi_base and configuration space
    : Exynos PCIe
      'pp->dbi_base' will be mapped in dw_pcie_host_init() of pcie-designware.c.

(drivers/pci/host/pcie-exynos.c)
static int __init exynos_pcie_probe(struct platform_device *pdev)
{
	struct resource *elbi_base;

	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	exynos_pcie->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);

(drivers/pci/host/pcie-designware.c)
int dw_pcie_host_init(struct pcie_port *pp)
{
	if (!pp->dbi_base) {
		pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
						resource_size(&pp->cfg));
		if (!pp->dbi_base) {
			dev_err(pp->dev, "error with ioremap\n");
			return -ENOMEM;
		}
	}


Best regards,
Jingoo Han


