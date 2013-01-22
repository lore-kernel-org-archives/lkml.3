Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3AVFHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:07:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39320 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AVFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:07:19 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-fa-50fe1e8571f7
From: Kukjin Kim <kgene.kim@samsung.com>
To: balbi@ti.com
Cc: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        p.paneri@samsung.com, cpgs@samsung.com
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
 <20130118131013.GG4672@arwen.pp.htv.fi> <20130118131250.GH4672@arwen.pp.htv.fi>
In-reply-to: <20130118131250.GH4672@arwen.pp.htv.fi>
Subject: RE: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Mon, 21 Jan 2013 21:06:58 -0800
Message-id: <053501cdf85e$507c2560$f1747020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGFTfvmY5tuG2fENKiAK4/ph/p6AwFq5CpaAdFTrUaYzD5XEA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA91WuX8BBsd/MFtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlbF/ykzmgi3cFRMO3WVvYJzM2cXIwSEhYCLR
	fzu3i5ETyBSTuHBvPVsXIxeHkMAyRomV7U1sEAkTiS97t7JDJBYxSjxf8ZQVwvnLKHHnwBJm
	kCo2AQ2Jw++fsYPYIgICEutfXALrYBY4zSSxd/ErZoiOWYwS+763g1VxAs290/sPrFtYwEli
	0dm5LCA2i4CqxKuvt8FsXgFLif4JZ6BsQYkfk++B2cwCWhKbtzWxQtjyEpvXvGWGuFVBYsfZ
	14wQVzhJXDmwnBGiRlxi0oOHYBdJCKxjl/i4ZBUbxDIBiW+TD7FAAkNWYtMBqDmSEgdX3GCZ
	wCgxC8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525ihMSc1A7GlQ0W
	hxgFOBiVeHgtHv0NEGJNLCuuzD3EKMHBrCTC2/8PKMSbklhZlVqUH19UmpNafIgxGejYicxS
	osn5wHSQVxJvaGxsYmZiamJuaWpuSpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoYC02j
	gjba636tkpNc8dkq03/XdJcNbCV5asUaefv38kn7VnyxW2y/6unbLtYHnLVblnr+ndQgtD90
	vvVF94pu3Tg9YfnalIeZ23vVrk5a3FeblJM8Zf/LvTvdz7MHxxgsPLn75PQYCVnbrLm/dm55
	8npGbvukbQ45L864Hdu2Zlns/fd7XwUHKbEUZyQaajEXFScCAJpJFnX9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd0WuX8BBgvW21hc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixf8pM
	5oIt3BUTDt1lb2CczNnFyMkhIWAi8WXvVnYIW0ziwr31bF2MXBxCAosYJZ6veMoK4fxllLhz
	YAkzSBWbgIbE4ffPwDpEBAQk1r+4xA5SxCxwmkli7+JXzBAdsxgl9n1vB6viBNpxp/cfWLew
	gJPEorNzWUBsFgFViVdfb4PZvAKWEv0TzkDZghI/Jt8Ds5kFtCQ2b2tihbDlJTavecsMcauC
	xI6zrxkhrnCSuHJgOSNEjbjEpAcP2ScwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgmH4mtYNxZYPFIUYBDkYlHl6LR38DhFgTy4orcw8xSnAwK4nw9v8D
	CvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MN3klcQbGpuYGVkamVkYmZibkyasJM7LeOpJ
	gJBAemJJanZqakFqEcwWJg5OqQbGlB2sKZcZ73rPi0xxExO58Jj9h9LbosPmshWumXr6f3X7
	kiu8NjxdNH0720+tHX7XS5Z7v27esDx2xeVnBW6HmWqezdq83v5mwIflronumhJOOl/m6a5j
	apyyb3XQ6/65zJ/yTqpJveGMMuA2b997/MCE6WtiUrmWCB2r5Zp1X7s5mrV1i6qjEktxRqKh
	FnNRcSIApp/Uyi0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> 
> On Fri, Jan 18, 2013 at 03:10:13PM +0200, Felipe Balbi wrote:
> > Hi,
> >
> > On Tue, Dec 18, 2012 at 09:09:40PM +0530, Vivek Gautam wrote:
> > > This patch-set enables the samsung-usbphy driver on exynos5250,
> > > which enables the support for USB2 type and USB3 type phys.
> > > The corresponding phy driver patches are available at:
> > >  1) https://lkml.org/lkml/2012/12/18/201
> > >  2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-
> December/024559.html
> > >
> > > Tested this patch-set on exynos5250 with following patch-sets for
> > > USB 2.0 and USB 3.0:
> > >  - https://patchwork.kernel.org/patch/1794651/
> > >  - https://lkml.org/lkml/2012/12/18/201
> > >  - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-
> December/024559.html
> > >  - http://comments.gmane.org/gmane.linux.usb.general/76352
> > >  - https://lkml.org/lkml/2012/12/13/492
> > >
> > > Vivek Gautam (2):
> > >   ARM: Exynos5250: Enabling samsung-usbphy driver
> > >   ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver
> >
> > What should I do with this series ? Is it ready to apply ? If it is,
> > then please resend with Kukjim's Acked-by.
> 
> actually, now that I look again, it's all under arch/arm/, so Kukjim can
> take all of those through his tree ;-)
> 
Yes, once Vivek addresses comments from Sylwester, let me pick up into
Samsung tree :-)

Thanks.

- Kukjin

