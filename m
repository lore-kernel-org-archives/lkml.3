Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaEAAxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:53:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16428 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaEAAxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:53:09 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-1a-53619af3a021
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000401cf6367$cc461500$64d23f00$@samsung.com>
 <20140429144759.GL17007@arm.com> <008e01cf643f$3e67eff0$bb37cfd0$@samsung.com>
 <20140430131224.GD31220@arm.com>
In-reply-to: <20140430131224.GD31220@arm.com>
Subject: Re: [PATCH v4 4/7] arm64: Add a description on 48-bit address space
 with 4KB pages
Date: Thu, 01 May 2014 09:53:07 +0900
Message-id: <000001cf64d7$b78fe200$26afa600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFBGkz5dCrKcMPvFcAYB1mhgrfVFQGgwAMmAjJkWRYCfkMBl5wU7rWw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zke7nWYnBBn2HrC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	58+zzAVNwhV7b19lbGB8y9fFyMkhIWAicaHxCiuELSZx4d56ti5GLg4hgWWMEh+WPmOCKboy
	5w0biC0kMJ1R4liXL0TRH0aJHbPOs4Mk2AQ0JR7d7QGzRQT0JRZfucEKUsQs0MEssfTpMkaI
	jrWMEl3fe5lBqjgFdCU+zr4EZgsLxEq0NB4F62YRUJX4vfw32GpeAUuJtzM+MUPYghI/Jt9j
	AbGZBbQk1u88zgRhy0tsXvOWGeJUBYkdZ18zQlzhJvG/8yZUjYjEvhfvwI6QEJjLIbFz2SJG
	iGUCEt8mHwIaygGUkJXYdABqjqTEwRU3WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ
	6UVGesWJucWleel6yfm5mxghaaBvB+PNA9aHGJOB1k9klhJNzgemkbySeENjMyMLUxNTYyNz
	SzPShJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGhvkWgZYXNY+qTaz43zndOO
	rfbMEn7N/P9CqczHdxIVVnMjF6uf1VX/KbPpc+Vip6sf7J1X5qRuuCskcotbSF+2wqc5xm//
	r8Xlx5oyYzvvzN440fmx9fqJqbWBD5bkhjv9njl90YdXUoITDEtY2t/uYOMy29tiu/DmpLib
	QfKaJ9XXXckrO6/EUpyRaKjFXFScCAAzEKPmGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQd3PsxKDDdonmln8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjJ0/zzIXNAlX7L19lbGB8S1fFyMnh4SAicSVOW/YIGwx
	iQv31oPZQgLTGSWOdfl2MXIB2X8YJXbMOs8OkmAT0JR4dLcHzBYR0JdYfOUGK0gRs0AHs8TS
	p8sYITrWMkp0fe9lBqniFNCV+Dj7EpgtLBAr0dJ4FKybRUBV4vfy30wgNq+ApcTbGZ+YIWxB
	iR+T77GA2MwCWhLrdx5ngrDlJTavecsMcaqCxI6zrxkhrnCT+N95E6pGRGLfi3eMExiFZiEZ
	NQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCSeSa1g3Flg8UhRgEO
	RiUe3glsicFCrIllxZW5hxglOJiVRHi3OAKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y
	APNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXHLUqXDaesm
	F6g+9GDQ9Il4r6+zbZGx4JcH+qWbMrtiZN0ac5vzZl5N7pdj4X7svOHUv18mM2avuGpo1vme
	r4H/6NrtPwQur3BO2PwmTNT4UNJ7/WUx9yoLZzFtZb4msNZiT2D6Nc6K5I9Lu2ZvmF+ldaAo
	qMo8/wDjn8urSherzWwI33BL8YESS3FGoqEWc1FxIgCRBu3HdgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 10:12 PM, Catalin Marinas wrote:
> On Wed, Apr 30, 2014 at 07:41:40AM +0100, Jungseok Lee wrote:
> > On Tuesday, April 29, 2014 11:48 PM, Catalin Marinas wrote:
> > > On Tue, Apr 29, 2014 at 05:59:27AM +0100, Jungseok Lee wrote:
> > > > --- a/Documentation/arm64/memory.txt
> > > > +++ b/Documentation/arm64/memory.txt
> > > > @@ -8,10 +8,11 @@ This document describes the virtual memory
> > > > layout used by the AArch64  Linux kernel. The architecture allows
> > > > up to 4 levels of translation  tables with a 4KB page size and up to 3 levels with a 64KB page
> size.
> > > >
> > > > -AArch64 Linux uses 3 levels of translation tables with the 4KB
> > > > page -configuration, allowing 39-bit (512GB) virtual addresses for
> > > > both user -and kernel. With 64KB pages, only 2 levels of
> > > > translation tables are -used but the memory layout is the same.
> > > > +AArch64 Linux uses 3 levels and 4 levels of translation tables
> > > > +with the 4KB page configuration, allowing 39-bit (512GB) and
> > > > +48-bit
> > > > +(256TB) virtual addresses, respectively, for both user and kernel.
> > > > +With 64KB pages, only 2 levels of translation tables are used but
> > > > +the memory layout is the same.
> > >
> > > Any reason why we couldn't use 48-bit address space with 64K pages (implying 3 levels)?
> >
> > No technical reason.
> > Since 64K+3levels is not implemented in this set, I didn't add it.
> >
> > Should 64K+3levels be prepared in this patchset?
> >
> > > > -AArch64 Linux memory layout with 64KB pages:
> > > > +AArch64 Linux memory layout with 4KB pages + 4 levels:
> > > > +
> > > > +Start			End			Size		Use
> > > > +-----------------------------------------------------------------------
> > > > +0000000000000000	0000ffffffffffff	 256TB		user
> > > > +
> > > > +ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc
> > >
> > > BTW, maybe as a separate patch we should change the "end" to be
> > > exclusive. It becomes harder to modify (I've been through this a few times already ;)) and even
> follow the changes.
> >
> > Does "exclusive" mean that 0000ffffffffffff is changed to 0001000000000000?
> > Or Does it mean that "End" column is dropped?
> 
> Not dropped but changed to 0001.... (the kernel already prints the memory layout in a similar way).

I see. I will make it as a separate patch.

Best Regards
Jungseok Lee

