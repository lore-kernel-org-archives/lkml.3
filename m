Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3H1IRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:17:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17182 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3H1IR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:17:27 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-b0-521db2151098
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
 <20130823083539.GB3937@pratyush-vbox>
In-reply-to: <20130823083539.GB3937@pratyush-vbox>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Date: Wed, 28 Aug 2013 17:17:24 +0900
Message-id: <001801cea3c7$06bca9d0$1435fd70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6f28+a/xoNj5uATiKdEyEb171RbwD6tUhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zQ13RTbJBBkv/8Vv8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRnHZpKTmZJalFunbJXBlTHn2jbHgqXDF7A7OBsaNfF2MnBwS
	AiYSx1q7WCFsMYkL99azdTFycQgJLGOUOLnmOFCCA6xoz0I9iPgiRombG1qZIZxfjBK3zjYz
	gnSzCahJfPlymB3EFhHQkTi+YilYEbPAfRaJA1/XMIEkhARSJfbf3Qu2jlPASOLI/qlgzcIC
	FhJnGy+xgdgsAqoSj+6/B4vzCthKnGv4zw5hC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZohL
	1SUe/dWFuMFI4sPG3cwQJSIS+168YwS5R0LgAodE3/WVjBC7BCS+TT7EAtErK7HpADMkJCQl
	Dq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQISSC9
	OxhvH7A+xJgMtH4is5Rocj4wAeWVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgXHbAut5DlWdDLslontl64oM2texqN+bv//SKaVPfzZNTQ/Z56rz
	0GjCjP/VOQ5e1V8tX3SnMLLWa88ok6usj4/kfup7j/XB132CHg4RnzKvBPFsC335Vt7jr2f6
	+lkhyQxcre8DK66myUuVHJganXTpsltR8M2Vx1xTvA5svblW+U/hZkWzeiWW4oxEQy3mouJE
	AJP9DUk2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xgK7oJtkggx2nOC3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAPlFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYx
	Zkx59o2x4KlwxewOzgbGjXxdjBwcEgImEnsW6nUxcgKZYhIX7q1n62Lk4hASWMQocXNDKzOE
	84tR4tbZZkaQKjYBNYkvXw6zg9giAjoSx1csBStiFrjPInHg6xomkISQQKrE/rt7WUFsTgEj
	iSP7p4I1CwtYSJxtvMQGYrMIqEo8uv8eLM4rYCtxruE/O4QtKPFj8j0WEJtZQEti/c7jTBC2
	vMTmNW+ZIa5Wl3j0VxfiBiOJDxt3M0OUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAhOT8+kdjCubLA4xCjAwajEw2uxWSZIiDWxrLgy9xCj
	BAezkghvyX+gEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDU2deSbyhsYmZkaWRmYWRibk5
	acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCev8XIOSPN7xuP6Zpp7sWvl7G8i3y56v+e
	vMC7S8yjpU0WMS0Ss/kgPUVNO+yP8/9i09dHg79n+s4MO5xWLiAsf87bZs61WEMtHuePwr+/
	mDQpfLI4uNdk5my7u3sN10vfmde9/vo1i+w1HmuZzK9yneL1/cBydu9JeTG37iqZSwX7DkQw
	2UxRYinOSDTUYi4qTgQA4rkEQJMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 23, 2013 5:36 PM, Pratyush Anand wrote:
> On Fri, Aug 23, 2013 at 02:04:20PM +0800, Jingoo Han wrote:

[.....]

> > +#define MAX_MSI_IRQS                   32
> 
> DW MSI controller can support upto 256. However, 32 seems a practical
> choice, as there might not be any system which may use more
> than 32. But a comment like as follows can be put here:
> 
> /*
> * Maximum number of MSI IRQs can be 256 per controller. But keep
> * it 32 as of now. Probably we will never need more than 32. If needed,
> * then increment it in multiple of 32.
> */

OK.
I will add this comment.

> 
> > +#define MAX_MSI_CTRLS                  8
> 
> Why to waste cpu cycles when MAX_MSI_IRQS is 32 only.
> #define MAX_MSI_CTRLS   (MAX_MSI_IRQS / 32)

OK.
I will fix it as you guide.

> 
> > +
> > +static unsigned int msi_data;
> > +static DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> 
> What if one has more than one RC.
> There are SOCs which support 3 RCs.
> So something like this:
> 
> #define MAX_PCIE_PORT_SUPPORTED 3
> static DECLARE_BITMAP(msi_irq_in_use[MAX_PCIE_PORT_SUPPORTED],
>                   NUM_MSI_IRQS);
> static unsigned int *msi_data[MAX_PCIE_PORT_SUPPORTED];

No, there is no need to do it.
Without this, we can use 3 RCs by adding a node of 3rd RC to dt file.

> 
> Allocate msi_data using __get_free_pages(GFP_KERNEL, 0)) as Thierry
> suggested.

OK.
I will use '__get_free_pages(GFP_KERNEL, 0))' as Thierry guide.

> >  int dw_pcie_link_up(struct pcie_port *pp)
> >  {
> >         if (pp->ops->link_up)
> > @@ -225,6 +432,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >                 return -EINVAL;
> >         }
> >
> > +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +               if (of_property_read_u32(np, "msi-base", &pp->msi_irq_start)) {
> > +                       dev_err(pp->dev, "Failed to parse the number of lanes\n");
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
> 
> What if an implementor want to use irq_domain method for msi_irq_start
> allocation? Is it fine to return error if msi-base is not passed from
> dt?

Sure, I will consider using irq_domain method.

>
> Also, with the limited knowledge of dt I do not understand one thing, how
> would dt understand that you have used 32 msi irqs (MAX_MSI_IRQS)?

Sorry, I cannot understand exactly. :-(
I will look into it.

I really appreciate your comments. :-)

Best regards,
Jingoo Han

