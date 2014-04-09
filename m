Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaDIKV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:21:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35217 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaDIKVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:21:54 -0400
X-AuditID: cbfee68e-b7f566d000002344-48-53451f41f96a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Vasut'" <marex@denx.de>, "'Graham Moore'" <grmoore@altera.com>
Cc: ggrahammoore@gmail.com, "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Brian Norris'" <computersforpeace@gmail.com>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "'Sourav Poddar'" <sourav.poddar@ti.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Geert Uytterhoeven'" <geert+renesas@linux-m68k.org>,
        "'Insop Song'" <insop.song@gainspeed.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Alan Tull'" <atull@altera.com>,
        "'Dinh Nguyen'" <dinguyen@altera.com>,
        "'Yves Vandervennet'" <rocket.yvanderv@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
 <1396973570-13995-2-git-send-email-grmoore@altera.com>
 <201404091206.45967.marex@denx.de>
 <000801cf53dc$ba81e820$2f85b860$%han@samsung.com>
In-reply-to: <000801cf53dc$ba81e820$2f85b860$%han@samsung.com>
Subject: Re: [PATCH] Add support for flag status register on Micron chips.
Date: Wed, 09 Apr 2014 19:21:52 +0900
Message-id: <000901cf53dd$86a71b50$93f551f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9T2371lVlz6hiyS0KQcaKLvRpMpwAAJgEwAABDJKA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t8zA11Heddgg57dXBZvHj9jtuif3Mlm
	ceTCWmaL45cWM1tMXDmZ2WLW/WNMFjM/LGG2mLH9BZvF923LWC0uL7wEJHbNYbPY3bSM3eJN
	WyOjxaqeiawWf7dvYrGY1vWIyUHAo3XvBDaPebNOsHhc7TrA4rFz1l12j80rtDwOHe5g9Jh3
	MtBj85J6j/6/Bh59W1Yxehy/sZ3J4/MmuQCeKC6blNSczLLUIn27BK6MuweWshf0c1ds2b+T
	sYHxAEcXIyeHhICJRPvP00wQtpjEhXvr2boYuTiEBJYxStxa9JMFpmjzyr+MEIlFjBJdh/dA
	Ob8ZJe7/6WQHqWITUJP48uUwmC0i4Cax48IGsFHMAodYJC7NO8kK0XGFUeLcvLdgVZwCdhJr
	Lr4DWy4s4CVxeBPEPhYBVYl9qzYBxTk4eAVsJX7frAcJ8woISvyYfA+shFlAS2L9zuNMELa8
	xOY1b5lByiUE1CUe/dWFuMFKYsGVp6wQJSIS+168Y4QoecAhMd0JYpGAxLfJh1ggwrISmw4w
	Q/wrKXFwxQ2WCYwSs5DsnYVk7ywke2chWbCAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4m
	RkhS6dvBePOA9SHGZKD1E5mlRJPzgUkpryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwGvteNm9QWbO++Zb1bZkJ4u7n+H9e7ng0w+O+zOrd+7qe
	ifmI+s4pX6DyoS+wQDtEa3Gr69mOwguGJgoFx6d6TOVs/P8+ZZ5MxbxA57OvY3sWivFnJBSW
	Ok82W2sqFvn11d10lUsZb+O/T+7QqXJ4dJfx/W5Wt3RrvWfXF9/jDvtVyiZvV1KixFKckWio
	xVxUnAgAT+OAmUADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42I5/e+xgK6jvGuwQddzZos3j58xW/RP7mSz
	OHJhLbPF8UuLmS0mrpzMbDHr/jEmi5kfljBbzNj+gs3i+7ZlrBaXF14CErvmsFnsblrGbvGm
	rZHRYlXPRFaLv9s3sVhM63rE5CDg0bp3ApvHvFknWDyudh1g8dg56y67x+YVWh6HDncwesw7
	GeixeUm9R/9fA4++LasYPY7f2M7k8XmTXABPVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QT0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwjrGjLsHlrIX9HNXbNm/k7GB8QBHFyMnh4SAicTmlX8ZIWwxiQv31rN1MXJxCAks
	YpToOryHEcL5zShx/08nO0gVm4CaxJcvh8FsEQE3iR0XNoB1MAscYpG4NO8kK0THFUaJc/Pe
	glVxCthJrLn4jgnEFhbwkji86ScLiM0ioCqxb9UmoDgHB6+ArcTvm/UgYV4BQYkfk++BlTAL
	aEms33mcCcKWl9i85i0zSLmEgLrEo7+6EDdYSSy48pQVokREYt+Ld4wTGIVmIZk0C8mkWUgm
	zULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNp6JrWDcWWDxSFGAQ5GJR5eRUuX
	YCHWxLLiytxDjBIczEoivM/ZXIOFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YUvNK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgdFQSb7Hm80h+aNMX9+m
	uO8nApfeSVe7padx+Fh5heev6Yd3Lj8cUO1+aW3b3B3JH7zWRdxdtI3XPoGl+cuS8zO2rH1b
	fEFNi++77Y+lG5Ypt1YEqkV3tixOTYlVKrvTu2G1HVeJpMWJfScmO3+ud3B/MXNK8JeZK5Od
	XKPcjjxYd3Qx48GX3KeVWIozEg21mIuKEwHVUWWqnwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2014 7:16 PM, Jingoo Han wrote:
> On Wednesday, April 09, 2014 7:07 PM, Marek Vasut wrote:
> > On Tuesday, April 08, 2014 at 06:12:50 PM, grmoore@altera.com wrote:
> > > From: Graham Moore <grmoore@altera.com>
> > >
> > > Some new Micron flash chips require reading the flag
> > > status register to determine when operations have completed.
> > >
> > > Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
> > > require reading the status register before reading the flag status
> > > register.
> > >
> > > This patch adds support for the flag status register in the n25q512a1 and
> > > n25q00 Micron QSPI flash chips.
> >
> > [...]
> >
> > > +static int read_fsr(struct m25p *flash)
> > > +{
> > > +	ssize_t retval;
> > > +	u8 code = OPCODE_RDFSR;
> > > +	u8 val;
> > > +
> > > +	retval = spi_write_then_read(flash->spi, &code, 1, &val, 1);
> > > +
> > > +	if (retval < 0) {
> > > +		dev_err(&flash->spi->dev, "error %d reading FSR\n",
> > > +				(int) retval);
> >
> > Is the type-cast really needed here? Why ?
> 
> The type-cast looks clumsy.
> The type of 'retval' is retval; thus, '%zd' can be used,

Sorry, there is a typo!
s/retval/ssize_t

The type of 'retval' is "ssize_t"; thus, '%zd' can be used,
instead of '%d', as below.

 +		dev_err(&flash->spi->dev, "error %zd reading FSR\n",
 +				retval);

Best regards,
Jingoo Han

