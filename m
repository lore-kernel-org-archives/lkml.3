Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3JIKu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:50:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14836 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3JIKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:50:24 -0400
X-AuditID: cbfee68e-b7f756d000004512-c6-525534ac51c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
 <52551C6E.1040404@ti.com> <003901cec4d0$5d83e650$188bb2f0$%han@samsung.com>
 <5255266B.6040809@ti.com> <000501cec4d7$1233a3f0$369aebd0$%han@samsung.com>
 <52552F84.2020901@ti.com>
In-reply-to: <52552F84.2020901@ti.com>
Subject: Re: [PATCH] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 19:49:15 +0900
Message-id: <000c01cec4dd$32d92070$988b6150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7E2iov1gM0Hxg1TNSocIyaK2vtawAAuCSg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zY901JqFBBn2N4hZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZ19dMZCp4KlTxa9cv9gbGifxdjJwc
	EgImEv9/bGWEsMUkLtxbz9bFyMUhJLCMUWJnWx8rTFH3gu3sEInpjBJPP15khXB+MUosOnqW
	CaSKTUBN4suXw+wgtoiAjsTC0+uZQWxmgZssErdeqkI0fGWUWDDzFtg+TqCGN6c+gxUJC9hJ
	NG38wgZiswioSvxofgE2lFfAVmLzbYihvAKCEj8m32OBGKolsX7ncSYIW15i85q3QHM4gE5V
	l3j0VxfiBiOJ93P/sEOUiEjse/EO6s0zHBJbX7JArBKQ+Db5EAtEq6zEpgPMECWSEgdX3GCZ
	wCgxC8niWUgWz0KyeBaSDQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihKSQvh2MNw9Y
	H2JMBlo/kVlKNDkfmILySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cC4dnFZbezSQyk/2A51LtNVdzD/c/p45nzzpt+fDsy/vbJ+RsO61zVLJp9e
	WL7DcubC3ES5w/uPNDyeEj3rwAzDGyf2Xr7c4btvXkOLlsv2OG/WXd5BW15+4qw7ueGzRl6t
	8bXIrZaH/30V9PT7GxOzydfmCI/Lnm169alFLwUPF+gmbDsdt2uDnBJLcUaioRZzUXEiAJEk
	nWM3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xoO4ak9AggyPnBCz+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAPlFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYx
	ZlxfM5Gp4KlQxa9dv9gbGCfydzFyckgImEh0L9jODmGLSVy4t56ti5GLQ0hgOqPE048XWSGc
	X4wSi46eZQKpYhNQk/jy5TBYh4iAjsTC0+uZQWxmgZssErdeqkI0fGWUWDDzFiNIghOo4c2p
	z2BFwgJ2Ek0bv7CB2CwCqhI/ml+ADeUVsJXYfBtiKK+AoMSPyfdYIIZqSazfeZwJwpaX2Lzm
	LdAcDqBT1SUe/dWFuMFI4v3cP+wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCU9Qz6R2MqxosDjEKcDAq8fA+4A8JEmJNLCuuzD3EKMHB
	rCTCu14qNEiINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HpM68k3tDYxMzI0sjMwsjE3Jw0
	YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGLsV3j6KnCpqr+Ze+TTHf+m0t45Mt7d3/U5R
	P3xwUmSTj1HYTquHnYsusE8Jjdy6I6mJq+HIMY25CoIMIXWeUf95Cvbw7Lglol1T+4Ol1s9R
	t8Dgze9yjstiaXbtacfmze6vuhW2xsA0eKNNgnnSrWm+m6dGWG39+eO3+u0TJvvfzXVk11nJ
	rsRSnJFoqMVcVJwIAOioqSqVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 09, 2013 7:27 PM, Kishon Vijay Abraham I wrote:
> On Wednesday 09 October 2013 03:35 PM, Jingoo Han wrote:
> > On Wednesday, October 09, 2013 6:48 PM, Kishon Vijay Abraham I wrote:
> >> On Wednesday 09 October 2013 02:47 PM, Jingoo Han wrote:
> >>> On Wednesday, October 09, 2013 6:06 PM, Kishon Vijay Abraham I wrote:
> >>>> On Wednesday 09 October 2013 01:39 PM, Jingoo Han wrote:
> >>>>> Without irq_create_mapping(), the correct irq number cannot be
> >>>>> provided. In this case, it makes problem such as NULL deference.
> >>>>> Thus, irq_create_mapping() should be added for MSI.
> >>>>>
> >>>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>>>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>> ---
> >>>>> Tested on Exynos5440.
> >>>>>
> >>>>>  drivers/pci/host/pcie-designware.c |   10 ++++------
> >>>>>  drivers/pci/host/pcie-designware.h |    1 +
> >>>>>  2 files changed, 5 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> >>>>> index 8963017..e536bb6 100644
> >>>>> --- a/drivers/pci/host/pcie-designware.c
> >>>>> +++ b/drivers/pci/host/pcie-designware.c
> >>>>> @@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> >>>>>  		}
> >>>>>  	}
> >>>>>
> >>>>> +	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
> >>>>> +
> >>>>
> >>>> I think irq_create_mapping should be done for all the MSI irq lines instead of
> >>>> only the first line. So you might have to do for MAX_MSI_IRQS lines.
> >>
> >> Maybe it should be only till MAX_MSI_IRQS-1?
> 
> I meant something like this,
> 
> 	for (i = 0; i < MAX_MSI_IRQS; i++)
> 		irq_create_mapping(pp->irq_domain, i);
>
> That didn't give me any issues though.

However, no driver calls irq_create_mapping() like this.
For example, Tegra PCI driver gives 'hwirq' as single offset value
to irq_create_mapping() without any loop.

static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
                               struct msi_desc *desc)
{
	hwirq = tegra_msi_alloc(msi);
	irq = irq_create_mapping(msi->domain, hwirq);

Maybe, the following can be used, it uses 'pos0' as the offset value.

	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, pos0);
	irq = pp->msi_irq_start;


Best regards,
Jingoo Han

