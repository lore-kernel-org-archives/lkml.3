Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEGE1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:27:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59675 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaEGE1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:27:52 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-35-5369b63d663e
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Steve Capper'" <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
References: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
 <20140506120131.GA26776@linaro.org>
In-reply-to: <20140506120131.GA26776@linaro.org>
Subject: Re: [PATCH v5 5/6] arm64: mm: Implement 4 levels of translation tables
Date: Wed, 07 May 2014 13:27:40 +0900
Message-id: <001d01cf69ac$aedeeb90$0c9cc2b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLeVLXF14hWIlib+IwkCJqi5P6lawLC2n7YmQCYMNA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zsa7ttsxggx/X+Sz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	1e5FjAUv+CseLfrI1MB4lqeLkZNDQsBEYsn2SawQtpjEhXvr2boYuTiEBJYxSmw4sYcRpmjt
	yZlMILaQwHRGiQW/VSGK/jBKPPwwH6yITUBT4tHdHnYQW0RAR+LktTawqcwCHcwSPQdYIJrj
	Je693wg2iFPAQGLZoe/MILawgL/EgsUvweIsAqoStz5PBJvJK2Ap8anxL5QtKPFj8j0WiJla
	Epu3NUHNl5fYvOYtM8ShChI7zr5mhLjBSqJ78jQmiBoRiX0v3jGCHC0hMJND4tPp4ywQywQk
	vk0+BGRzACVkJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kYle
	cWJucWleul5yfu4mRkgKmLCD8d4B60OMyUDrJzJLiSbnA1NIXkm8obGZkYWpiamxkbmlGWnC
	SuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwdl9KP5Psldv46fmsmnuCs590n4g7
	v2++/eZP3+RavxssLhQ4/afm3xrWZ+tmzH89waE9+Or9619vNSWt3ih+8ktOzp0SN7WOs5bm
	CZr3FxlcefHs998pfsw/jhguT75UOPuHgEfPA2buKxN+GV377sFgGfe26KC4o3PPRw8n7cJC
	8zXWvy6sWabEUpyRaKjFXFScCAAuIQKdFwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV3bbZnBBmdvcVj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjFW7FzEWvOCveLToI1MD41meLkZODgkBE4m1J2cyQdhi
	EhfurWcDsYUEpjNKLPit2sXIBWT/YZR4+GE+I0iCTUBT4tHdHnYQW0RAR+LktTZWEJtZoINZ
	oucAC0RzvMS99xvBhnIKGEgsO/SdGcQWFvCXWLD4JVicRUBV4tbniWAzeQUsJT41/oWyBSV+
	TL7HAjFTS2Lztiao+fISm9e8ZYY4VEFix9nXjBA3WEl0T57GBFEjIrHvxTvGCYxCs5CMmoVk
	1Cwko2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjBPJPawbiyweIQowAHoxIP
	r8XbjGAh1sSy4srcQ4wSHMxKIryL1mYGC/GmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MPnl
	lcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOj1WOdnZFK/6WF
	P70TDaj+4H2U7d9aidijZ66VB3Xkhp/azz/9H59r16ws3z9Ttm5wKQv7cHjW5w0xlzfa1ufw
	cUv1+gSc9m478f6CdNESleZ/515fLim4WCGZ1/ln6faHHknd5v/MmYLlbuUVbNrqO3FtYdDD
	vV5bsgQK7G32ND6L/JCocL5diaU4I9FQi7moOBEA65E7wnQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2014 9:02 PM, Steve Capper wrote:
> On Thu, May 01, 2014 at 11:34:16AM +0900, Jungseok Lee wrote:
> > This patch implements 4 levels of translation tables since 3 levels of
> > page tables with 4KB pages cannot support 40-bit physical address
> > space described in [1] due to the following issue.
> >
> > It is a restriction that kernel logical memory map with 4KB + 3 levels
> > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> > 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> > mapping for this region in map_mem function since __phys_to_virt for
> > this region reaches to address overflow.
> >
> > If SoC design follows the document, [1], over 32GB RAM would be placed
> > from 544GB. Even 64GB system is supposed to use the region from 544GB
> > to 576GB for only 32GB RAM. Naturally, it would reach to enable 4
> > levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> >
> > However, it is recommended 4 levels of page table should be only
> > enabled if memory map is too sparse or there is about 512GB RAM.
> >
> 
> Hi Jungseok,
> One comment below:

Hi Steve.

> [ ... ]
> 
> > diff --git a/arch/arm64/include/asm/tlb.h
> > b/arch/arm64/include/asm/tlb.h index bc19101..086112b 100644
> > --- a/arch/arm64/include/asm/tlb.h
> > +++ b/arch/arm64/include/asm/tlb.h
> > @@ -100,6 +100,15 @@ static inline void __pmd_free_tlb(struct
> > mmu_gather *tlb, pmd_t *pmdp,  }  #endif
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +static inline void __pud_free_tlb(struct mmu_gather *tlb, pmd_t *pudp,
> > +				  unsigned long addr)
> 
> The second parameter needs to be a pointer to pud_t ?
> (this fires up a warning with STRICT_MM_TYPECHECKS).

You're right. My fault...

> With that and Christoffer's feedback about expanding the comments on create_pud_entry addressed:

Okay. I will add it.

> Reviewed-by: Steve Capper <steve.capper@linaro.org>

Thanks for review!

- Jungseok Lee

