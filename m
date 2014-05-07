Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaEGD7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:59:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45791 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbaEGD7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:59:13 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a8-5369af90b93a
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000201cf64e5$cd3366a0$679a33e0$@samsung.com>
 <20140501100628.GB2848@lvm> <000a01cf65a9$d3cbf030$7b63d090$@samsung.com>
 <20140502111648.GA3002@lvm>
In-reply-to: <20140502111648.GA3002@lvm>
Subject: Re: [PATCH v5 2/6] arm64: Introduce VA_BITS and translation level
 options
Date: Wed, 07 May 2014 12:59:12 +0900
Message-id: <001b01cf69a8$b49e5010$1ddaf030$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH+9ILDP1NwWGSuTOtSibrnayT7igJxjhgkAY+P5PEC7Gv1SZqd+6Ag
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zse6E9ZnBBqd/K1v8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	sgl7WQu28lasuruYpYFxF1cXIweHhICJxNNZkl2MnECmmMSFe+vZuhi5OIQEljFKfH/dyQaR
	MJF4sO0rVGIRo8THnw9ZQBJCAn8YJZY8kwCx2QQ0JR7d7WEHsUWAGj7fmwfWwCzwlkni945p
	7BDdixkl/t64DVbFKaAhMe/5K0YQW1ggROLTxtlMIDaLgKrEtN8zwTbwClhKPPz6ihnCFpT4
	MfkeWJxZQEti87YmVghbXmLzmrfMEKcqSOw4+5oR4go3iW2TvrND1IhI7HvxjhHkCAmBhRwS
	H68/YYRYJiDxbfIhFkhYyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILk
	guKk9CJjveLE3OLSvHS95PzcTYyQJNC/g/HuAetDjMlA6ycyS4km5wOTSF5JvKGxmZGFqYmp
	sZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGyIZ5udpRx2ju2/w7y7
	CTkt648oC8pu/9rJ8HzXkbkbI2dP1uhTs/4d3/h5U9cpSUYti842/WvHN3Ne7uL8Hb9r3i11
	NpUPLh7hO+172yxaslKfpbbPKbigJHiK2/3O4yIDu+NJny32qRd2zIhZnV8X4rdSQW7f3idZ
	HfcnBP0JPmA3bZVOthJLcUaioRZzUXEiAJMsjjoYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd0J6zODDS5fkrP4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygS5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGcsm7GUt2MpbseruYpYGxl1cXYycHBICJhIPtn1lg7DF
	JC7cWw9kc3EICSxilPj48yELSEJI4A+jxJJnEiA2m4CmxKO7PewgtghQ8+d788AamAXeMkn8
	3jGNHaJ7MaPE3xu3wao4BTQk5j1/xQhiCwuESHzaOJsJxGYRUJWY9nsm2AZeAUuJh19fMUPY
	ghI/Jt8DizMLaEls3tbECmHLS2xe85YZ4lQFiR1nXzNCXOEmsW3Sd3aIGhGJfS/eMU5gFJqF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBSeaZ1A7GlQ0WhxgF
	OBiVeHgt3mYEC7EmlhVX5h5ilOBgVhLhXbQ2M1iINyWxsiq1KD++qDQntfgQYzLQpxOZpUST
	84EJMK8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGGdIW+iF
	lIUwn726/XGOiRVrnO5TztqCn5tfmdx4zq/w6v32Atl7HDUfJ+g3L9h8nO3SUv7b66zebvMK
	VLm48MW3BSWHdIqU+SdI5/+/raAm1jXr8+x1M/7wfot5YO+y42VLvX9cxQrDFa8unJ/wdrcm
	9z0ln6my82s2yLI9n+T8d8LHW8kXp19VYinOSDTUYi4qTgQAkzCUtnYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 8:17 PM, Christoffer Dall wrote:
> On Fri, May 02, 2014 at 10:57:09AM +0900, Jungseok Lee wrote:
> > On Thursday, May 01, 2014 7:06 PM, Christoffer Dall wrote:
> > > On Thu, May 01, 2014 at 11:33:56AM +0900, Jungseok Lee wrote:
> 
> [...]
> 
> > > > +
> > > > +choice
> > > > +	prompt "Virtual address space size"
> > > > +	default ARM64_VA_BITS_39 if ARM64_4K_PAGES
> > > > +	default ARM64_VA_BITS_42 if ARM64_64K_PAGES
> > > > +	help
> > > > +	  Allows virtual address space size. A level of translation
> > > > +tables
> > >
> > > What does "Allows virtual address space size" mean exactly?
> >
> > It means that VA space size can be chosen. For example, there are two
> > VA size options, 39-bit and 48-bit, with 4KB pages. If 39-bit VA space
> > is not enough, 48-bit can be selected instead. The 5th patch adds a
> > 48-bit option to this choice blocks.
> >
> > If 16KB pages are supported with both 47-bit and 48-bit VA size,
> > people could configure it in menuconfig.
> >
> > In this context, I've written it down like page size.
> >
> > I think Catalin's comment would be helpful.
> > http://www.spinics.net/linux/lists/arm-kernel/msg319552.html
> >
> I didn't have problems understanding the concept, I was questioning the language.  The way it is
> written now it suggests having a virtual address space size, as opposed to not having a size at all,
> which doesn't make sense.
> 
> I think you want to say something along the lines of "Allows choosing a virtual address space size",
> or "Allows choosing one of multiple possible virtual address space sizes".

Ahh... I see. I will revise the sentence clearly.
Thanks!

- Jungseok Lee

