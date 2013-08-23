Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3HWE6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:58:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26253 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3HWE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:58:09 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-b0-5216ebdfe901
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
 <20130812105638.GA12042@ulmo>
In-reply-to: <20130812105638.GA12042@ulmo>
Subject: Re: [PATCH] PCI: exynos: add support for MSI
Date: Fri, 23 Aug 2013 13:58:07 +0900
Message-id: <002e01ce9fbd$5b728430$12578c90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AQFGJzktPramPcVSz76V2WYwCfRKBwHt7zEGmqO6uTA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zQ937r8WCDN7+UbX4O+kYu8WSpgyL
	l4c0LeYfOcdqcXnhJVaL3gVX2SwuPO1hs7i8aw6bxdl5x9ksZpzfx2SxceovRov2S8oWK5q2
	Mlr83DWPxeLpgyYmi8ajD1gtWp88YHQQ9Pj9axKjx5NNFxk9ds66y+6xYFOpx/eF89k9+ras
	YvR4+mMvs8fxG9uZPD5vkgvgjOKySUnNySxLLdK3S+DKeHnrOWvBOoGKCR+OMjUw/ufpYuTk
	kBAwkdh5YBczhC0mceHeerYuRi4OIYFljBL3t85mhClaNHMnM0RiEaPE7vt97BDOL0aJjne/
	warYBNQkvnw5zA5iiwjoS1y6fokVpIhZ4BqLxNTzv8ESQgKREt0dL8D2cQpoSTyY0wEWFxYw
	lbg48xkLiM0ioCqx8/52oKEcHLwCthLfX4GdyisgKPFj8j2wEmag1vU7jzNB2PISm9e8ZQYp
	lxBQl3j0VxfiBCuJrRvesEKUiEjse/GOEeQcCYELHBKf5sxgg1glIPFt8iEWiF5ZiU0HoCEh
	KXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgK
	6d/BePeA9SHGZKD1E5mlRJPzgSkoryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2M3bzWbc/+dZ3Nq0ydef3u3BjZSbMsNq449X/p26J5oW+s1obl
	7eYpes21yIXDbPnJM9cTbJe3xQgWWCRMFHBY//JS7JIrv9QtQypEp/1dIqdyN+N+xi6Nw/99
	t/EWFycebOxK2xVmHL3h5vPlv6Q/Sxi+lJjTruoS9COl+l/gt0nTLhltmNC1W4mlOCPRUIu5
	qDgRAO434jw3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xgO7912JBBieuyVv8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zHh56zlrwTqBigkfjjI1MP7n6WLk5JAQMJFYNHMnM4QtJnHh3nq2LkYuDiGBRYwSu+/3sUM4
	vxglOt79ZgSpYhNQk/jy5TA7iC0ioC9x6folVpAiZoFrLBJTz/8GSwgJREp0d7wAG8spoCXx
	YE4HWFxYwFTi4sxnLCA2i4CqxM7724GGcnDwCthKfH8FdhGvgKDEj8n3wEqYgVrX7zzOBGHL
	S2xe85YZpFxCQF3i0V9diBOsJLZueMMKUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOEE9k9rBuLLB4hCjAAejEg/vBGexICHWxLLiytxD
	jBIczEoivDargEK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0yeeSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqNJaf6fGKrPByvvb4Y6nSssuz9rHaR27
	/ZH4Pf2tn594+FzKXisZXDRhyZVihU9Vx17uZ66582jhjLyyjiuvhK1fcB+9PFNm/q+sBY9j
	nvcZVxxaq6a++UIo4zMNv1QJ/3XTL4Ycfuyv364nt+2MjcCJFZ58e5QTQgvkX5SL/vXK5lKY
	/98rSomlOCPRUIu5qDgRANsoF1CUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 12, 2013 7:57 PM, Thierry Reding wrote:
> On Mon, Aug 12, 2013 at 05:56:47PM +0900, Jingoo Han wrote:
> [...]
> > diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> > index 855d4a7..9ef1c95 100644
> > --- a/arch/arm/mach-exynos/Kconfig
> > +++ b/arch/arm/mach-exynos/Kconfig
> > @@ -93,6 +93,7 @@ config SOC_EXYNOS5440
> >  	default y
> >  	depends on ARCH_EXYNOS5
> >  	select ARCH_HAS_OPP
> > +	select ARCH_SUPPORTS_MSI
> 
> This symbol goes away in Thomas Petazzoni's MSI patch series which is
> targetted at 3.12, so I don't think you should add that here.

OK, I see.
I will remove ARCH_SUPPORTS_MSI.

[.....]

> > +#endif
> > +
> >  static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
> >  {
> >  	exynos_pcie_enable_irq_pulse(pp);
> > +#ifdef CONFIG_PCI_MSI
> > +	exynos_pcie_msi_init(pp);
> > +#endif
> >  	return;
> >  }
> 
> Instead of the whole #ifdef business above, can't you just use something
> like this in exynos_pcie_enable_interrupts():
> 
> 	if (IS_ENABLED(CONFIG_PCI_MSI))
> 		exynos_pcie_msi_init(pp);
> 
> Now you can drop the #ifdef guards and the compiler will throw away all
> the related code automatically if PCI_MSI is not selected because the
> functions are all static and unused. This has the advantage of compiling
> all the code whether or not PCI_MSI is selected or not, therefore
> increasing compile coverage of the driver.

OK, I see.
I will use 'if IS_ENABLED(CONFIG_PCI_MSI))', and remove #ifdef guards.

[.....]

> > +
> > +void arch_teardown_msi_irq(unsigned int irq)
> > +{
> > +	clear_irq(irq);
> > +}
> 
> And we've reworked this largely so that drivers no longer provide arch_*
> functions because that prevents multi-platform support. So I think you
> need to port this to the new msi_chip infrastructure that's being
> introduced in 3.12.

OK, I have looked at the new msi_chip infrastructure made by Thomas Petazzoni.
I will use this msi_chip.

I really appreciate your comment. :)
Thank you.

Best regards,
Jingoo Han


