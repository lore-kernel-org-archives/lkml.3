Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3KGIUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:20:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3KGITz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:19:55 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-3d-527b4d24e718
From: Jingoo Han <jg1.han@samsung.com>
To: "'Brian Norris'" <computersforpeace@gmail.com>,
        "'Gupta, Pekon'" <pekon@ti.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Daniel Mack'" <zonque@gmail.com>, avinashphilip@ti.com,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        tony@atomide.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
 <001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
 <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA31818@DBDE04.ent.ti.com>
 <20131107071909.GB3805@norris.computersforpeace.net>
In-reply-to: <20131107071909.GB3805@norris.computersforpeace.net>
Subject: Re: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Date: Thu, 07 Nov 2013 17:19:48 +0900
Message-id: <000301cedb92$1fa1f920$5ee5eb60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7biaqgqiSz+Ua4TgCRpHALcfpQ0QAAGr3w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+Zvq6Kb3WQwdx3MhZvHj9jtnh0Zz+T
	xZELa5ktJq6czGxxeeElVovLu+awWexuWsZuMbthF5vF/iteFh8uHWW22Lmuk92ic8Z6Jgce
	j29fJ7F47Jx1l91j8wotj3knAz02L6n36NuyitHj+I3tTB5L7x1l9Pi8SS6AM4rLJiU1J7Ms
	tUjfLoEr49vbz6wFvdwVH/+dYGtgPMLRxcjJISFgIrFy7ntmCFtM4sK99WxdjFwcQgLLGCWm
	dPWxwBRN+7MBKjGdUeLjmb+MEM4vRonJb3aDVbEJqEl8+XKYHcQWEQiW6Ny1mQnEZhZ4zSTR
	/NYFouEwk8SGx42MIAlOAUeJ3s7DrF2MHBzCAhESS1d7g4RZBFQlzk5tAwvzCthKfF1jDBLm
	FRCU+DH5HgvESC2J9TuPQ42Xl9i85i0zSLmEgLrEo7+6EBcYSdxZto4RokREYt+Ld2AnSwis
	5JDo/vycFWKVgMS3yYdYIHplJTYdgAaEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpRYZ6xYm5xaV56XrJ+bmbGCHpoHcH4+0D1ocYk4HWT2SWEk3OB6aTvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgTJZSnJ+c/2T9mqhH
	n5UtzWpyjL8JbrvOxidoaLyoaKbp8vjmrt2rg/bxVQufSD1iWcPnEvO9svKSMrPu9R19K/ar
	H3+qW2K7oM3aPN/76OxV92auCt8s/ddyNsejXb5TaiwnbrzwqiDkmMHB8CSpFVeLY+rMP69c
	Vt62ZGrC1U8vVJIfsBb9U2Ipzkg01GIuKk4EAB2vTaEdAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jQV0V3+oggzerxC3ePH7GbPHozn4m
	iyMX1jJbTFw5mdni8sJLrBaXd81hs9jdtIzdYnbDLjaL/Ve8LD5cOspssXNdJ7tF54z1TA48
	Ht++TmLx2DnrLrvH5hVaHvNOBnpsXlLv0bdlFaPH8RvbmTyW3jvK6PF5k1wAZ1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxvbz+zFvRyV3z8d4KtgfEIRxcjJ4eEgInE
	tD8b2CBsMYkL99YD2VwcQgLTGSU+nvnLCOH8YpSY/GY3C0gVm4CaxJcvh9lBbBGBYInOXZuZ
	QGxmgddMEs1vXSAaDjNJbHjcyAiS4BRwlOjtPMzaxcjBISwQIbF0tTdImEVAVeLs1DawMK+A
	rcTXNcYgYV4BQYkfk++xQIzUkli/8zjUeHmJzWveMoOUSwioSzz6qwtxgZHEnWXrGCFKRCT2
	vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnm2dS
	OxhXNlgcYhTgYFTi4Z1RUxUkxJpYVlyZe4hRgoNZSYTX3Kg6SIg3JbGyKrUoP76oNCe1+BBj
	MtCfE5mlRJPzgYkwryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4
	pYAxumj99y38sdWHN6XN+5JtsNW7YZu43OJFl9PdHjf+rl3+fLVSRYnSOpueY1fS1X7/OxRz
	yX02wzm+vo2fJt27fak3aL+YnGJ+fWvgu76/aTIm0xd1hslftJzQnLp4UaJ31cEdjEu/ny4N
	3ff6atXxzp/L+KXzLosvNWBcXm9eeD5wm8z+1PB3SizFGYmGWsxFxYkAR1vC7HoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 07, 2013 4:19 PM, Brian Norris wrote:
> On Wed, Nov 06, 2013 at 06:06:25PM +0000, Pekon Gupta wrote:
> > > From: Brian Norris [mailto:computersforpeace@gmail.com]
> > > > On Thu, Oct 31, 2013 at 7:18 PM, Jingoo Han <jg1.han@samsung.com>
> > > >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > >>
> > > >> Fix to return a negative error code from the error handling
> > > >> case instead of 0, as done elsewhere in this function.
> > > >
> > > > Commit message is right? :-(
> > >
> > > It sounds OK by my reading. Unless you're having trouble parsing what
> > > "as done elsewhere in this function" is being applied to. (IOW, is the
> > > rest of the function returning a negative error code on the error
> > > paths, or is it returning 0? Of course the answer is the former, but
> > > it's possible to misread it.) If it helps, I can try to tweak the
> > > wording a bit when applying this patch.
> > >
> > > Pekon, can I get an Acked-by?
> > >
> > Yes sure .. Sorry I was away from both mailbox and boards.
> 
> No problem.
> 
> > Acked-by: Pekon Gupta <pekon@ti.com>
> >
> > And thanks much Wei Yongjun for fixing this .
> 
> Thanks. Pushed to l2-mtd.git with a slight tweak in the description.

Hi Norris,

I checked the patch in l2-mtd.git.
The commit message looks good.
I understand what the patch means.
Thank you.

Best regards,
Jingoo Han

