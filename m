Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3H1CTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:19:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62140 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3H1CTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:19:46 -0400
X-AuditID: cbfee68e-b7f756d000004512-1c-521d5e3f6a5d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com> <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
In-reply-to: <20130828015834.GH10506@lizard>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Date: Wed, 28 Aug 2013 11:19:43 +0900
Message-id: <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jksNzBPxSqeoGQJ2CuGnm8G+flQAAIizw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY137ONkgg+XzzSzmrF/DZnFwq6bF
	1IdP2Cxe/5vOYjFx5WRmi+bF69ksLi+8xGox+/5jFovLu+awOXB6TOj/xOixeYWWx6ZVnWwe
	J2b8ZvHYP3cNu8fHp7dYPL6susbs0bdlFaPH501yAZxRXDYpqTmZZalF+nYJXBmd5z+wFFzg
	rXj15TZbA+MVri5GTg4JAROJmROWsEDYYhIX7q1n62Lk4hASWMYocXXtGnaYol2nroPZQgKL
	GCXa33tAFP1ilJi3tg2sm01ATeLLl8NgRSICGhJtq6ewgBQxCxxlknh5eSsbRPdLRolPu0pA
	bE4BHYl9s5czg9jCAhYS7d2tYM0sAqoSd45MB7I5OHgFbCU+PGMFCfMKCEr8mHyPBSTMLKAu
	MWVKLkiYWUBeYvOat8wgYQmg8KO/uhAXGElcXXSQBaJERGLfi3eMINdICMzkkPh56h8jxCYB
	iW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeBbC4llIFs9CsmEBI8sqRtHUguSC4qT0IiO9
	4sTc4tK8dL3k/NxNjJCI79vBePOA9SHGZKDtE5mlRJPzgQkjryTe0NjMyMLUxNTYyNzSjDRh
	JXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MxUpW3MxRi4TdeVh6p/W53ahq/T+z
	s7NzffTE7/qrrzp+kvt0LuZFenYD04SXcx/dN2oJ5Ek6wqA+L+Py3oCrNr+y1FdMWPLiEYtF
	z17LLfNLyte73zUP11JzeMq6rHr7T691dz9atmqfX7n62PyIMmUNt93P4t+uesCsPYXJ/Umh
	nfldS25pJZbijERDLeai4kQA6xKiIQ4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAV37ONkgg2s7DC3mrF/DZnFwq6bF
	1IdP2Cxe/5vOYjFx5WRmi+bF69ksLi+8xGox+/5jFovLu+awOXB6TOj/xOixeYWWx6ZVnWwe
	J2b8ZvHYP3cNu8fHp7dYPL6susbs0bdlFaPH501yAZxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJ6xgzOs9/YCm4wFvx6stttgbGK1xdjJwcEgImErtOXWeHsMUkLtxbzwZi
	CwksYpRof+/RxcgFZP9ilJi3to0FJMEmoCbx5cthsAYRAQ2JttVTWECKmAWOMkm8vLwVqvsl
	o8SnXSUgNqeAjsS+2cuZQWxhAQuJ9u5WsGYWAVWJO0emA9kcHLwCthIfnrGChHkFBCV+TL7H
	AhJmFlCXmDIlFyTMLCAvsXnNW2aQsARQ+NFfXYgLjCSuLjrIAlEiIrHvxTvGCYxCs5AMmoUw
	aBaSQbOQdCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxOnkntYFzZYHGIUYCDUYmH
	12KzTJAQa2JZcWXuIUYJDmYlEd6S/0Ah3pTEyqrUovz4otKc1OJDjMlAX05klhJNzgemuryS
	eENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYNyxdX7A6T+/ivxE
	D2k+N2BljdqicTGf5/YfU5X39uylr9W766MPxH3ICre/OyPgOOOb0yu/31lyQZlV4XXJ60KZ
	hfNzZbKfiHuwLjmU7nvofcXLZwoupbu1byyua5/deGT6HocVkawB3ysnH6pSlVmRxnMhxEvz
	yxHviMeb7gd8OMX7SEW4sF+JpTgj0VCLuag4EQBpqo4uawMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 10:59 AM, Anton Vorontsov wrote:
> On Tue, Aug 13, 2013 at 12:00:39PM +0300, Dan Carpenter wrote:
> > > > > Use the wrapper function for retrieving the platform data instead of
> > > > > accessing dev->platform_data directly.
> > > >
> > > > Um.. what is the benefit or rationale of this patch?
> > >
> > > CC'ed Joe Perches, Dan Carpenter
> > >
> > > Hi Anton Vorontsov,
> > >
> > > Usually, using the wrapper function makes the code simpler.
> > > Also, it make the code more readable.
> >
> > Since people are asking my opinion, then yes using
> > dev_get_platdata() as intended is better than open coding.  It's a
> > coding standard thing.
> 
> I don't see any immediate benefit of applying this patch... It does not
> fix anything now or in the near future (or we are about to add something
> into dev_get_platdata() wrapper, or get rid of dev.platform_data member?
> Any plans for this? Then it should be in the commit message.)

CC'ed Greg Kroah-Hartman, Andrew Morton, Mark Brown

The benefit is that this wrapper function makes the code simpler and
enhances readability. I don't know why you disagree. :(
Also, this is a cosmetic change which does not have harmful effect.

There is no special plan.
I just want to make the best use of this wrapper function in order to
enhance readability and make the code simpler.

> 
> Without any plans to actually use the wrapper the patch is just a churn
> [that might result into patch conflicts that I'll have to deal with], so
> I'll refrain from applying it.

Um, if you want, I will send v2 patch re-based on the latest git tree.
Please, consider this patch positively. :-)
Thank you.

Best regards,
Jingoo Han


