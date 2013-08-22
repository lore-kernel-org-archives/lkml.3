Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3HVFZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:25:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37657 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3HVFZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:25:29 -0400
X-AuditID: cbfee68f-b7f436d000000f81-f4-5215a0c7534d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
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
References: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
 <CAK9yfHwEPEfhMCWGbDWK2NQE2zAgmsQc6_Dn498pRP4UX6sYmQ@mail.gmail.com>
In-reply-to: <CAK9yfHwEPEfhMCWGbDWK2NQE2zAgmsQc6_Dn498pRP4UX6sYmQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: exynos: add support for MSI
Date: Thu, 22 Aug 2013 14:25:26 +0900
Message-id: <000101ce9ef8$024f1be0$06ed53a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AQFGJzktPramPcVSz76V2WYwCfRKBwLeajM3mpqtx3A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t8zI93jC0SDDP5e57H4O+kYu8WSpgyL
	l4c0LeYfOcdqcXnhJVaL3gVX2SwuPO1hs7i8aw6bxdl5x9ksZpzfx2SxceovRov2S8oWJ//0
	MlqsaNrKaPFz1zwWi6cPmpgsGo8+YLVoffKA0UHI4/evSYweTzZdZPTYOesuu8eCTaUe3xfO
	Z/e4c20Pm0ffllWMHk9/7GX2OH5jO5PH501yAVxRXDYpqTmZZalF+nYJXBm7Nj1nLdguVLHt
	BmcD41K+LkZODgkBE4ltl3cyQdhiEhfurWfrYuTiEBJYxijx8/BtJpiizZ+nMkMkFjFKvFwO
	4nACOb8YJT63qILYbAJqEl++HGYHsUUEdCRW7FrLBNLALNDKKnF4FoQjJNDAKHFj7xs2kCpO
	gWCJQ08awFYIC5hKXJz5jAXEZhFQlfjxeiojiM0rYCsxacJnKFtQ4sfke2A1zAJaEut3HmeC
	sOUlNq95C3QRB9Cp6hKP/uqCmCICVhJ3z7BDVIhI7HvxjhHkBAmBBxwSW6+/YIdYJSDxbfIh
	FohWWYlNB5ghHpaUOLjiBssERolZSBbPQrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4
	NC9dLzk/dxMjJKn072C8e8D6EGMy0PqJzFKiyfnApJRXEm9obGZkYWpiamxkbmlGmrCSOK9a
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb+7YerIrcnb7BumOK286u59bJluxM+6Dou
	lVKOW2ZsvnDJg1kHrz1wnpF9Zln6vp4Zrdwdq62WT5+hs2xmoP1DnYy7UvczhdnEDCbu0JPn
	X+nw42TCdBGOSfsOzJC1lvmmXFOwuuNG2LY7yzVtr5/R8Vxe8H7Lie0FK8WZbuuc3cI0Z/XN
	rlkflFiKMxINtZiLihMBzm3f9UADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42I5/e+xgO7xBaJBBrO2sFn8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLk396
	GS1WNG1ltPi5ax6LxdMHTUwWjUcfsFq0PnnA6CDk8fvXJEaPJ5suMnrsnHWX3WPBplKP7wvn
	s3vcubaHzaNvyypGj6c/9jJ7HL+xncnj8ya5AK6oBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCflBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGEdYwZuzY9Zy3YLlSx7QZnA+NSvi5GTg4JAROJzZ+nMkPYYhIX7q1n62Lk4hAS
	WMQo8XI5REJI4BejxOcWVRCbTUBN4suXw+wgtoiAjsSKXWuZQBqYBVpZJQ7PgnCEBBoYJW7s
	fcMGUsUpECxx6EkDE4gtLGAqcXHmMxYQm0VAVeLH66mMIDavgK3EpAmfoWxBiR+T74HVMAto
	SazfeZwJwpaX2LzmLdBFHECnqks8+qsLYooIWEncPcMOUSEise/FO8YJjEKzkAyahWTQLCSD
	ZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOGU9k9rBuLLB4hCjAAejEg/vhZ0i
	QUKsiWXFlbmHGCU4mJVEeL26RIOEeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YTvNK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTF9yv71y8+ySmb8e2H7
	/9+f9Yvv6tgbrHL/rHS6NM2h6PPkhuWfH9wSfHHwzd3z0k//3zO6efDy5euCmnrN+hJnZ1db
	fw69mtg84UGtxn/f+4VCfvNmK3jnTFKX5Wh02rN1TuTjVf82TYq+uaDoql2SepxuU+fE0Am/
	ldzu7eHjObs/Wpn3iFClEktxRqKhFnNRcSIA1CfaPZ0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 12, 2013 6:13 PM, Sachin Kamat wrote:
> On 12 August 2013 14:26, Jingoo Han <jg1.han@samsung.com> wrote:
> > This patch adds support for Message Signaled Interrupt in the
> > Exynops PCIe diver using Synopsys designware PCIe core IP.
> 
> s/Exynops PCIe diver/Exynos PCIe driver

OK, I will fix this typo.

> > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---
> >  arch/arm/boot/dts/exynos5440.dtsi  |    2 +
> >  arch/arm/mach-exynos/Kconfig       |    1 +
> >  drivers/pci/host/pci-exynos.c      |   60 ++++++++++
> >  drivers/pci/host/pcie-designware.c |  213 ++++++++++++++++++++++++++++++++++++
> >  drivers/pci/host/pcie-designware.h |    8 ++
> >  5 files changed, 284 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
> > index 586134e..3746835 100644
> > --- a/arch/arm/boot/dts/exynos5440.dtsi
> > +++ b/arch/arm/boot/dts/exynos5440.dtsi
> > @@ -249,6 +249,7 @@
> >                 interrupt-map-mask = <0 0 0 0>;
> >                 interrupt-map = <0x0 0 &gic 53>;
> >                 num-lanes = <4>;
> > +               msi-base = <200>;
> 
> Please update the bindings documentation too.

OK, I will updated the bindings documentation.

[.....]

> > +#ifdef CONFIG_PCI_MSI
> > +static void exynos_pcie_clear_irq_level(struct pcie_port *pp)
> > +{
> > +       u32 val;
> > +       struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> > +       void __iomem *elbi_base = exynos_pcie->elbi_base;
> > +
> > +       val = readl(elbi_base + PCIE_IRQ_LEVEL);
> > +       writel(val, elbi_base + PCIE_IRQ_LEVEL);
> 
> Sorry, I did not get this. Writing the value read from the same
> register without any operation.

It was intended to clear the bits by writing 1 of each bit.
But I will remove this function.

My coworker, Srikanth T Shivanand found that this function is
unnecessary. This is because PCIE_IRQ_LEVEL register is read-only
register. Also, PCIE_IRQ_LEVEL register is already cleared before
this function is called.

Thank you for your comment.

Best regards,
Jingoo Han


