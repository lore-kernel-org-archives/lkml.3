Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3EPCSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:18:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29601 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3EPCSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:18:42 -0400
X-AuditID: cbfee68f-b7f436d000000f81-a1-51944200b4e2
Date: Thu, 16 May 2013 02:18:40 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
To: Tomasz Figa <t.figa@samsung.com>, Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko St?bner <heiko@sntech.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516021223232@jg1.han
Msgkey: 20130516021223232@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516021223232@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <23026896.124001368670717989.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zY10GpymBBt2XNS0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmTJ76mLngmnDFwYUdjA2ME4S7GDk5hASUJCad3MsIYksImEjsWfwQ
	yhaTuHBvPVsXIxdQzTJGiaf/m5lhihad+sgMkZjPKPHg4xV2kASLgKpE38vvTCA2m4C6xITf
	zSwgtrCAp8TzGStYQWwRgRCJj5uXsIA0MwvsY5b4dLyLFeIMWYl7k2eDbeAVEJQ4OfMJUBEH
	0DYFiSu/wiDCihJ93z6wQhwhIXHn/n4om1diRvtTFghbTmLa1zVQh0pLnJ+1Ae6bxd8fQ8X5
	JY7d3sEEMZ5X4sn9YJgxuzd/YYOwBSSmnjkI1aoq0bXvFtR4Pok1C99C2YISp691M8P03t8y
	F+x1ZqAzp3Q/ZIewtSS+/NjHhu4rXgEniT3zhCYwKs9CkpmFpHsWkm5kNQsYWVYxiqYWJBcU
	J6UXGSNH9iZGSBrs38F494D1Icb9jMAomcgsJZqcD0ykeSXxhsZmRhamJqbGRuaWZhQKm5ha
	WJgYUUVYSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjkpRorOYXzWqZZO+gjCOS
	VXmXZjOET+05nNy72a3s1ARuZ20V3fPGV/gP3pjBs/5Pf6rEptze8MktNxjvdrnfWsPJMidy
	95sptZrd2lmRmabc9tLTWCax3y/TFbVvlI1eckQh787qKd+3JM0zT7UxO55s9nxGhaN5usl0
	u+eyV6+mc3/kc1ViKc5INNRiLipOBABtlbXK9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TF0GpymBBkvOqFpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jMlTHzMXXBOuOLiwg7GBcYJwFyMnh5CAksSkk3sZQWwJAROJRac+MkPYYhIX7q1n62LkAqqZ
	zyjx4OMVdpAEi4CqRN/L70wgNpuAusSE380sILawgKfE8xkrWEFsEYEQiY+bl7CANDML7GOW
	+HS8ixVim6zEvcmzwTbwCghKnJz5BKiIA2ibgsSVX2EQYUWJvm8fWCGOkJC4c38/lM0rMaP9
	KQuELScx7esaqEOlJc7P2sAIc/Ti74+h4vwSx27vYIIYzyvx5H4wzJjdm7+wQdgCElPPHIRq
	VZXo2ncLajyfxJqFb6FsQYnT17qZYXrvb5kL9joz0JlTuh+yQ9haEl9+7GND9xWvgJPEnnlC
	ExjlZiHJzELSPQtJN7KaBYwsqxhFUwuSC4qT0iuM9IoTc4tL89L1kvNzNzGCE9SzRTsY/523
	PsQowMGoxMPrYDIlUIg1say4MvcQowQHs5IIr4INUIg3JbGyKrUoP76oNCe1+BBjMjD+JjJL
	iSbnA5NnXkm8obGxiZmJqbmBhYGlOWnCSuK8z1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw6t0X
	NKt79sQnZWotw5+9T/vfthj7LV8xwf2KYdHfi3LR107W5WgfOlT6aLG8jcyunDsp14o1+bfV
	3Txxqk0p7NvMuvSeUr+oaK3FXI1Zbeqpp26vvH2w915Osah+ic+kiWtl2Q9WvnuxcMPE5rOC
	v7Ypyqb3/CjVDLO+uGetjc/hPVJJSqteKrEUZyQaajEXFScCAB2v+PeUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G2Ioe9018999

On Tuesday, May 14, 2013 11:22 PM Tomasz Figa wrote:
> 
> Hi Linus, Heiko,
> 
> On Tuesday 14 of May 2013 14:47:19 Linus Walleij wrote:
> > On Sat, May 11, 2013 at 1:31 PM, Heiko St?bner <heiko@sntech.de> wrote:
> > > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > > with numerous virtual channels being mapped to a lot less physical ones.
> > > The driver therefore borrows a lot from the amba-pl08x driver in this
> > > regard. Functionality-wise the driver gains a memcpy ability in addition
> > > to the slave_sg one.
> > >
> > > The driver currently only supports the "newer" SoCs which can use any
> > > physical channel for any dma slave. Support for the older SoCs where
> > > each channel only supports a subset of possible dma slaves will have to
> > > be added later.
> > >
> > > Tested on a s3c2416-based board, memcpy using the dmatest module and
> > > slave_sg partially using the spi-s3c64xx driver.
> > >
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> >
> > So have I understood correctly if I assume that *some* S3C
> > variants, i.e. this: arch/arm/mach-s3c64xx/dma.c
> > have a vanilla, unmodified, or just slightly modified
> > PL08x block, while this DMAC is something probably based on
> > the PL08x where some ASIC engineer has had a good time hacking
> > around in the VHDL code to meet some feature requirements.
> > Correct? Or plausible guess?
> >
> > Exactly *how* far away from the pl08x hardware is it?
> 
> AFAIK the DMAC of S3C24xx is completely different from PL08x. I think Heiko
> just meant that it uses similar concepts, like virtual channels.

Yes, right.
the DMAC of S3C24xx is completely different from PL08x.
As Heiko mentioned, the DMAC of S3C24xx is 'home grown' as other IPs of S3C24xx.

Best regards,
Jingoo HanˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
