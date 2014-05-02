Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaEBCNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 22:13:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16933 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaEBCNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 22:13:07 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-72-5362ff3046c4
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000301cf64e5$d27f9a20$777ece60$@samsung.com>
 <20140501100612.GA2848@lvm>
In-reply-to: <20140501100612.GA2848@lvm>
Subject: Re: [PATCH v5 3/6] arm64: Add a description on 48-bit address space
 with 4KB pages
Date: Fri, 02 May 2014 11:13:03 +0900
Message-id: <000101cf65ac$0ce4b850$26ae28f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGbuvn88CNa98TrKafROVAkSaCfXQIzH4f7m4JGwHA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zka7B/6Rgg58P5Sz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	1vfFrAWHZCvufzvI2sB4WLyLkZNDQsBEYsWsl0wQtpjEhXvr2boYuTiEBJYxSnQcXsUGU7Tx
	zg0WiMR0RomzE/9CVf1hlDj0rhesnU1AU+LR3R52EFsEqOPzvXlgRcwCb5kkfu+YBpYQEgiX
	eLz4JyOIzSmgIfH14yGwuLBArMTMB//ABrEIqEqc6O1lBbF5BSwlWpY+YoSwBSV+TL7HAmIz
	C2hJrN95nAnClpfYvOYtM8SpChI7zr5mhDjCSuL3tgVQNSIS+168Y4Somckhsbc1FmKXgMS3
	yYeAZnIAxWUlNh2AGiMpcXDFDZYJjBKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqRoV5x
	Ym5xaV66XnJ+7iZGSBLo3cF4+4D1IcZkoPUTmaVEk/OBSSSvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd6kh0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjPMK0KDrz57cbih0J77kcoMTvb20+f
	Z7e2t0eEWaydz+JToOsn6Y3pW+dbff10TCb8ddmRoqtHPxT8e6GcxPiCL6LTTbji+6O3IknP
	umzuXnK5tyNsst3/o4+Nv0fe/PFRX2jvmYyeO4KT5vf9P+to8547a+cKGwX9jdxSNirrrLqM
	7LZNtglRYinOSDTUYi4qTgQAF0KQyRgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQV2D/0nBBk/WS1r8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjFnfF7MWHJKtuP/tIGsD42HxLkZODgkBE4mNd26wQNhi
	EhfurWfrYuTiEBKYzihxduJfKOcPo8Shd71MIFVsApoSj+72sIPYIkDdn+/NAytiFnjLJPF7
	xzSwhJBAuMTjxT8ZQWxOAQ2Jrx8PgcWFBWIlZj74BzaIRUBV4kRvLyuIzStgKdGy9BEjhC0o
	8WPyPbCTmAW0JNbvPM4EYctLbF7zlhniVAWJHWdfM0IcYSXxe9sCqBoRiX0v3jFOYBSahWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwUnmmdQOxpUNFocYBTgY
	lXh4NXKTgoVYE8uKK3MPMUpwMCuJ8DZkAIV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5gA
	80riDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUen2GvHny1c2
	hiyxXWjs71McclKy06jP/VjaWTOpk9rPXwhvYKidMLvFhu2aunvkhWfLfB3LdzZ0Csw0Slik
	uXvTOXdetnj1rmBZ7xVP7wqcSiu6wXnq5RoeKY7PZg8vxHQZiR4I9i462yL0X/hy9EvDA4+9
	5C5aJ+c9D7FVmq14M1v8+/z9SizFGYmGWsxFxYkA2+7gl3YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2014 7:06 PM, Christoffer Dall wrote:
> On Thu, May 01, 2014 at 11:34:05AM +0900, Jungseok Lee wrote:
> > This patch adds memory layout and translation lookup information about
> > 48-bit address space with 4K pages. The description is based on 4
> > levels of translation tables.
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  Documentation/arm64/memory.txt |   59 ++++++++++++++++++++++++++++++++++------
> >  1 file changed, 51 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/arm64/memory.txt
> > b/Documentation/arm64/memory.txt index d50fa61..8142709 100644
> > --- a/Documentation/arm64/memory.txt
> > +++ b/Documentation/arm64/memory.txt
> > @@ -8,10 +8,11 @@ This document describes the virtual memory layout
> > used by the AArch64  Linux kernel. The architecture allows up to 4
> > levels of translation  tables with a 4KB page size and up to 3 levels with a 64KB page size.
> >
> > -AArch64 Linux uses 3 levels of translation tables with the 4KB page
> > -configuration, allowing 39-bit (512GB) virtual addresses for both
> > user -and kernel. With 64KB pages, only 2 levels of translation tables
> > are -used but the memory layout is the same.
> > +AArch64 Linux uses 3 levels and 4 levels of translation tables with
> 
> uses either 3 or 4 levels of translation?

Yes, you are right. I will fix it.

> > +the 4KB page configuration, allowing 39-bit (512GB) and 48-bit
> > +(256TB) virtual addresses, respectively, for both user and kernel.
> > +With 64KB pages, only 2 levels of translation tables are used but the
> > +memory layout is the same.
> 
> Perhaps it's worth clarifying that with 64KB and 2 levels of translation tables we are limited to a
> 42-bit address space here.

Okay, I will add it.

> >
> >  User addresses have bits 63:39 set to 0 while the kernel addresses
> > have  the same bits set to 1. TTBRx selection is given by bit 63 of
> > the @@ -21,7 +22,7 @@ The swapper_pgd_dir address is written to TTBR1
> > and never written to  TTBR0.
> >
> >
> > -AArch64 Linux memory layout with 4KB pages:
> > +AArch64 Linux memory layout with 4KB pages + 3 levels:
> >
> >  Start			End			Size		Use
> >  -----------------------------------------------------------------------
> > @@ -48,7 +49,34 @@ ffffffbffc000000	ffffffbfffffffff	  64MB		modules
> >  ffffffc000000000	ffffffffffffffff	 256GB		kernel logical memory map
> >
> >
> > -AArch64 Linux memory layout with 64KB pages:
> > +AArch64 Linux memory layout with 4KB pages + 4 levels:
> > +
> > +Start			End			Size		Use
> > +-----------------------------------------------------------------------
> > +0000000000000000	0000ffffffffffff	 256TB		user
> > +
> > +ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc
> > +
> > +ffff7bffffff0000	ffff7bffffffffff	  64KB		[guard page]
> > +
> > +ffff7c0000000000	ffff7dffffffffff	   2TB		vmemmap
> > +
> > +ffff7e0000000000	ffff7ffffbbfffff	  ~2TB		[guard, future vmmemap]
> 
> hmm, I may be completely confused, but if VMALLOC_END is defined to be (PAGE_OFFSET - UL(0x400000000)
> - SZ_64K), how can we squeeze ~4TB into a 16 GB hole?

In the 5th patch, VMALLOC_END is changed to (PAGE_OFFSET - UL(0x40000000000)
- SZ_64K) when 4 level is set.

> > +
> > +ffff7ffffa000000	ffff7ffffaffffff	  16MB		PCI I/O space
> > +
> > +ffff7ffffb000000	ffff7ffffbbfffff	  12MB		[guard]
> > +
> > +ffff7ffffbc00000	ffff7ffffbdfffff	   2MB		earlyprintk device
> 
> shouldn't this be "fixed mappings" now?

Thanks!! I will fix it.

Best Regards
Jungseok Lee

