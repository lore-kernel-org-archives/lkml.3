Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3GHFGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:06:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3GHFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:06:20 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-50-51da48ca5b8d
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
Date: Mon, 08 Jul 2013 14:06:18 +0900
Message-id: <002801ce7b98$e1520f60$a3f62e20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQII16kcxw44AVHNORO1PoktmeAs2wG+yqifmNeLeAA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zY91THrcCDWbNM7T4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvF5V1z2CzOzjvOZjHj/D4mi41TfzFatF9Stmg8+oDVovXJA0YHHo/f
	vyYxeizYVOrxfeF8do++LasYPZ7+2Mvs8XmTXABbFJdNSmpOZllqkb5dAlfGzIMzmQo2ile0
	9ls3MM7g72Lk5JAQMJE4u/M8C4QtJnHh3nq2LkYuDiGBZYwSy7oes8AUtc2dzgSRmM4o8elU
	AwuE84tR4mXXXXaQKjYBNYkvXw6D2SICARJbrx5jBCliFjjLJLHwyTdGkISQQKjEj75TYEWc
	QA3fnqxmA7GFBeIkJrx6DhZnEVCV2DNxEpjNK2ApMWnVckYIW1Dix+R7YCcxC2hJrN95nAnC
	lpfYvOYtM8SpChI7zr5mhDjCSqK/8RwjRI2IxL4X78AOkhCYyCHx9+RtJohlAhLfJh8CGsoB
	lJCV2HQAao6kxMEVN1gmMErMQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFhnrFibnFpXnp
	esn5uZsYIVHfu4Px9gHrQ4zJQOsnMkuJJucDk0ZeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhgXsqT0TF11+98L7wzbWWKxj57GRrA5lG9Y/lU/
	hFuTgTn4jNxm09s3l67+OOvs3nmrmSuCD+5NPnWWY0rFq/bbYe+thIpCFCcr1J44xdhp/V6T
	02mj0LFlaoKcHR8uFJxzeu+7+MO7W9tbH2ZdOeQUe+pkfbvCuieBj1+bnYsUEnN3msCjXjFd
	iaU4I9FQi7moOBEAI9UD0hADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd1THrcCDRZ/1rb4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvF5V1z2CzOzjvOZjHj/D4mi41TfzFatF9Stmg8+oDVovXJA0YHHo/f
	vyYxeizYVOrxfeF8do++LasYPZ7+2Mvs8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QhUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwjrGjJkHZzIVbBSvaO23bmCcwd/FyMkhIWAi0TZ3OhOELSZx4d56ti5GLg4h
	gemMEp9ONbBAOL8YJV523WUHqWITUJP48uUwmC0iECCx9eoxRpAiZoGzTBILn3xjBEkICYRK
	/Og7BVbECdTw7clqNhBbWCBOYsKr52BxFgFViT0TJ4HZvAKWEpNWLWeEsAUlfky+xwJiMwto
	SazfeZwJwpaX2LzmLTPEqQoSO86+ZoQ4wkqiv/EcI0SNiMS+F+8YJzAKzUIyahaSUbOQjJqF
	pGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCU8kxqB+PKBotDjAIcjEo8vBKnbwYK
	sSaWFVfmHmKU4GBWEuEVZ70VKMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wHSXVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MfAc9vMPmndO+uUL85YF6
	g3Atr8qQYyfNhK2PfJt5t8vFOyjkSHxavGvZEpWMFqal177tvhWwTdwq1aXD5UPkoU4WxT4B
	wfyZ805su2aSH35cwcJLpOiH5fmPddkh3xdErdmtO3uivevMNy6+EcELFpatvKnJIbRlqsnR
	+JKwUFvbjzcuv1iqxFKckWioxVxUnAgArp8+g20DAAA=
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

Thank you.
Without your comment, it could be done. :)

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
> 
> [...]
> 
> 
> > -
> > -struct pcie_port {
> > -       struct device           *dev;
> > -       u8                      controller;
> > -       u8                      root_bus_nr;
> > -       void __iomem            *dbi_base;
> > -       void __iomem            *elbi_base;
> > -       void __iomem            *phy_base;
> > -       void __iomem            *purple_base;
> 
> Just for knowledge, what is the purple_base. It might not be needed by
> all vendors. Can we explain the name in comment or can give some generic
> name?

purple_base is a register to control PCIe block.

For example, controlling various reset control signals, 
PLL lock indication, etc.

Generic name would be 'block_base' or 'misc_base'?


> 
> > -       u64                     cfg0_base;
> > -       void __iomem            *va_cfg0_base;
> > -       u64                     cfg1_base;
> > -       void __iomem            *va_cfg1_base;
> > -       u64                     io_base;
> > -       u64                     mem_base;
> > -       spinlock_t              conf_lock;
> > -       struct resource         cfg;
> > -       struct resource         io;
> > -       struct resource         mem;
> > -       struct pcie_port_info   config;
> > -       struct clk              *clk;
> > -       struct clk              *bus_clk;
> > -       int                     irq;
> > -       int                     reset_gpio;
> > -};
> > -
> 
> [...]
> 
> > -
> > -static inline void readl_rc(struct pcie_port *pp, void *dbi_base, u32 *val)
> > +static inline void dw_pcie_readl_rc(struct pcie_port *pp, void *dbi_base,
> > +                               u32 *val)
> 
> dbi_base is part of pp. So why to pass 3 args?

OK, I see.
I will use 2 args.

Best regards,
Jingoo Han



