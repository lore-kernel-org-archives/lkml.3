Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3GHGzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:55:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25958 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GHGza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:55:30 -0400
X-AuditID: cbfee68e-b7f276d000002279-2e-51da625baf6e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
 <51D6A370.7060604@st.com>
In-reply-to: <51D6A370.7060604@st.com>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Mon, 08 Jul 2013 15:55:23 +0900
Message-id: <002d01ce7ba8$1e532250$5af966f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQII16kcxw44AVHNORO1PoktmeAs2wG+yqifmNenvzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zfd3opFuBBpebdC3+TjrGbrGkKcPi
	5SFNi8sLL7Fa9C64ymZxedccNouz846zWcw4v4/JYuPUX4wW7ZeULRqPPmC1aH3ygNGBx+P3
	r0mMHgs2lXp8Xzif3aNvyypGj6c/9jJ7fN4kF8AWxWWTkpqTWZZapG+XwJVx9YB6wUbRiqXX
	1jI2MF7n72Lk5JAQMJFYdn87C4QtJnHh3nq2LkYuDiGBZYwSx3ffZOxi5AAr+rCpDCK+iFFi
	+tYjzBDOL0aJy+dnMIJ0swmoSXz5cpgdxBYRCJDYevUYI0gRs8BZJomFT76BFQkJhEr86DsF
	VsQJ1PDtyWo2EFtYIE5iwqvnYHEWAVWJi2e2gdm8ApYSXctusEHYghI/Jt8DO5VZQEti/c7j
	TBC2vMTmNW+ZIV5QkNhx9jUjxBFWEgdu3WOFqBGR2PfiHdhBEgJTOSS+rdnLCLFMQOLb5EMs
	EG/KSmw6ADVHUuLgihssExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8
	dL3k/NxNjJCY79vBePOA9SHGZKD1E5mlRJPzgSkjryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M7NyFBa/NuB5+jjjd8/Civk5izpI7gRqJpvpz
	v4iYrNOcYS16a3qc4os/1ZF7z6kpZsdsOFA7zSjZfku233PH21zX13yfcd+2br7jrc7zt7dc
	eyrwpUw06VMly5wpcZL2hp4ZPjqsnr9TcoJtfq/QW/KqqDnj+aLes67eN+4I3DXc8lDPcQWv
	EktxRqKhFnNRcSIA4Ss5gA8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd3opFuBBjMnqVn8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3i8q45bBZn5x1ns5hxfh+Txcapvxgt2i8pWzQefcBq0frkAaMDj8fv
	X5MYPRZsKvX4vnA+u0ffllWMHk9/7GX2+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYR1jxtUD6gUbRSuWXlvL2MB4nb+LkYNDQsBE4sOmsi5GTiBTTOLCvfVsXYxc
	HEICixglpm89wgzh/GKUuHx+BiNIFZuAmsSXL4fZQWwRgQCJrVePMYIUMQucZZJY+OQbWJGQ
	QKjEj75TYEWcQA3fnqxmA7GFBeIkJrx6DhZnEVCVuHhmG5jNK2Ap0bXsBhuELSjxY/I9FhCb
	WUBLYv3O40wQtrzE5jVvmSFOVZDYcfY1I8QRVhIHbt1jhagRkdj34h3jBEahWUhGzUIyahaS
	UbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxQnknvYFzVYHGIUYCDUYmHV+L0
	zUAh1sSy4srcQ4wSHMxKIrzirLcChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmOzySuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFx9fx9Fve8WgUPMSbt
	2J1nw/fu10n/XfNL5qxrOi4sUr804a3mj3K/jFCmg5f2TbjveDWz7PGyGcIPrtx+3GwV0nXv
	+JOs3rSev94JjS+Orpr8YAPbe7EKdsFU+zXnrbwYEzaK3+Arae/YuWK+yQchm5ItzVPW8Ki6
	rbBtWM1fJH9/wcQvVVdjlFiKMxINtZiLihMBVSbwrWwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 7:44 PM, Pratyush Anand wrote:
> On 7/5/2013 1:59 PM, Jingoo Han wrote:
> > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > specific part. Only core block is a Synopsys designware part;
> > other parts are Exynos specific.
> > Also, the Synopsys designware part can be shared with other
> > platforms; thus, it can be split two parts such as Synopsys
> > designware part and Exynos specific part.
> >
> 
> A quick and nice job :)
> Just few minor comments.
> 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---
> >   drivers/pci/host/Makefile          |    1 +
> >   drivers/pci/host/pcie-designware.c |  907 +++++++-----------------------------
> >   drivers/pci/host/pcie-designware.h |   72 +++
> >   drivers/pci/host/pcie-exynos.c     |  619 ++++++++++++++++++++++++
> >   4 files changed, 862 insertions(+), 737 deletions(-)
> >   create mode 100644 drivers/pci/host/pcie-designware.h
> >   create mode 100644 drivers/pci/host/pcie-exynos.c
> >

[...]

> > -static inline void readl_rc(struct pcie_port *pp, void *dbi_base, u32 *val)
> > +static inline void dw_pcie_readl_rc(struct pcie_port *pp, void *dbi_base,
> > +                               u32 *val)
> 
> dbi_base is part of pp. So why to pass 3 args?

Sorry, this variable does not mean dbi_base;
it means 'dbi_base + offset'.

dw_pcie_{readl/writel}_rc() are called as below:

  dw_pcie_readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
  dw_pcie_writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);

Thus, 'dbi_base' can be replaced with 'dbi_addr'.


Best regards,
Jingoo Han


> 
> >   {
> > -       exynos_pcie_sideband_dbi_r_mode(pp, true);
> > -       *val = readl(dbi_base);
> > -       exynos_pcie_sideband_dbi_r_mode(pp, false);
> > -       return;
> > +       if (pp->ops->readl_rc)
> > +               pp->ops->readl_rc(pp, dbi_base, val);
> 
> ditto
> 
> > +       else
> > +               *val = readl(dbi_base);
> >   }
> >
> > -static inline void writel_rc(struct pcie_port *pp, u32 val, void *dbi_base)
> > +static inline void dw_pcie_writel_rc(struct pcie_port *pp, u32 val,
> > +                               void *dbi_base)
> 
> ditto
> 
> >   {
> > -       exynos_pcie_sideband_dbi_w_mode(pp, true);
> > -       writel(val, dbi_base);
> > -       exynos_pcie_sideband_dbi_w_mode(pp, false);
> > -       return;
> > +       if (pp->ops->writel_rc)
> > +               pp->ops->writel_rc(pp, val, dbi_base);
> 
> ditto
> 
> > +       else
> > +               writel(val, dbi_base);
> >   }
> 
> 
> Regards
> Pratyush

