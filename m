Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaEBB5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 21:57:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21965 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaEBB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 21:57:12 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-97-5362fb75ca29
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
 <20140501100628.GB2848@lvm>
In-reply-to: <20140501100628.GB2848@lvm>
Subject: Re: [PATCH v5 2/6] arm64: Introduce VA_BITS and translation level
 options
Date: Fri, 02 May 2014 10:57:09 +0900
Message-id: <000a01cf65a9$d3cbf030$7b63d090$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQH+9ILDP1NwWGSuTOtSibrnayT7igJxjhgkmrnYSvA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+ZsW7p76Rgg7UvNCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	+/dlzAUTnCue3V3E3MB417SLkZNDQsBEYkHjDFYIW0ziwr31bCC2kMAyRolf10Jhak703QCK
	cwHFFzFKnO27xwzh/GGU+LboLyNIFZuApsSjuz3sILYIUMfne/PAOpgF3jJJ/N4xjR1ibLjE
	2SerwRo4BTQkLsy/zwRiCwuESHzaOBvMZhFQlfh5sgWshlfAUuLn9/3MELagxI/J91hAbGYB
	LYn1O48zQdjyEpvXvGWGOFVBYsfZ14wQcRGJfS/eMUIcZCXRt3YvI8hBEgIzOSSe7H/ABrFM
	QOLb5ENAQzmAErISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsW8DIsopRNLUguaA4Kb3I
	UK84Mbe4NC9dLzk/dxMjJAn07mC8fcD6EGMy0PqJzFKiyfnAJJJXEm9obGZkYWpiamxkbmlG
	mrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyrjzs85p8Vrrrj7fzdzoUsD9uv
	2N6PnBQ44faSg9dWF172UavRa9w76eQU9uhd7/ZOOv1W+IT/q48Ri9N1riuofpwZa/P6k96f
	50uazCqck29ekE/Sf2rv9TPYq2PfuqN84v2Ht0VbbIzZN/1h5pSL2/I3f4rd9O9S3tuM4Af7
	FJ0are8Lav18r8RSnJFoqMVcVJwIAIzaNgYYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd3S30nBBo8vK1n8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjO3flzEXTHCueHZ3EXMD413TLkZODgkBE4kTfTfYIGwx
	iQv31gPZXBxCAosYJc723WOGcP4wSnxb9JcRpIpNQFPi0d0edhBbBKj78715YB3MAm+ZJH7v
	mAaWEBIIlzj7ZDVYA6eAhsSF+feZQGxhgRCJTxtng9ksAqoSP0+2gNXwClhK/Py+nxnCFpT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zBCnKkjsOPuaESIuIrHvxTtGiIOsJPrW7mWcwCg0C8mo
	WUhGzUIyahaS9gWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPMM6kdjCsbLA4xCnAw
	KvHwauQmBQuxJpYVV+YeYpTgYFYS4W3IAArxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjAB
	5pXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD47Szd22M7N/e
	LFt7T2RnXkDC4rWP1Fd1ewraHI0ryfy9iWtdia17xsHnef/j/ym1c9QxVmw+0LJuxqQnl3dO
	YnZ5cHVeCEPIhw0ikYaVNzeb952KyyqeItNrGRC1TtirVVxvTexql5VRHy2Wps2cpWjI4Z07
	dcKhGYr9LDk/GZf5Bh7aFx9xUYmlOCPRUIu5qDgRAO5TAi12AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2014 7:06 PM, Christoffer Dall wrote:
> On Thu, May 01, 2014 at 11:33:56AM +0900, Jungseok Lee wrote:
> > This patch adds virtual address space size and a level of translation
> > tables to kernel configuration. It facilicates introduction of
> > different MMU options, such as 4KB + 4 levels, 16KB + 4 levels and
> > 64KB + 3 levels, easily.
> >
> > The idea is based on the discussion with Catalin Marinas:
> > http://www.spinics.net/linux/lists/arm-kernel/msg319552.html
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm64/Kconfig                     |   45 +++++++++++++++++++++++++++++++-
> >  arch/arm64/include/asm/memory.h        |    6 +----
> >  arch/arm64/include/asm/page.h          |    2 +-
> >  arch/arm64/include/asm/pgalloc.h       |    4 +--
> >  arch/arm64/include/asm/pgtable-hwdef.h |    2 +-
> >  arch/arm64/include/asm/pgtable.h       |    8 +++---
> >  arch/arm64/include/asm/tlb.h           |    2 +-
> >  7 files changed, 54 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index
> > e759af5..b438540 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -144,14 +144,57 @@ endmenu
> >
> >  menu "Kernel Features"
> >
> > +choice
> > +	prompt "Page size"
> > +	default ARM64_4K_PAGES
> > +	help
> > +	  Allows page size.
> > +
> > +config ARM64_4K_PAGES
> > +	bool "4KB"
> > +	help
> > +	  This feature enables 4KB pages support.
> > +
> >  config ARM64_64K_PAGES
> > -	bool "Enable 64KB pages support"
> > +	bool "64KB"
> >  	help
> >  	  This feature enables 64KB pages support (4KB by default)
> >  	  allowing only two levels of page tables and faster TLB
> >  	  look-up. AArch32 emulation is not available when this feature
> >  	  is enabled.
> >
> > +endchoice
> > +
> > +choice
> > +	prompt "Virtual address space size"
> > +	default ARM64_VA_BITS_39 if ARM64_4K_PAGES
> > +	default ARM64_VA_BITS_42 if ARM64_64K_PAGES
> > +	help
> > +	  Allows virtual address space size. A level of translation tables
> 
> What does "Allows virtual address space size" mean exactly?

It means that VA space size can be chosen. For example, there are
two VA size options, 39-bit and 48-bit, with 4KB pages. If 39-bit
VA space is not enough, 48-bit can be selected instead. The 5th patch
adds a 48-bit option to this choice blocks.

If 16KB pages are supported with both 47-bit and 48-bit VA size,
people could configure it in menuconfig.

In this context, I've written it down like page size.

I think Catalin's comment would be helpful.
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

> s/A level/The level/

Okay, I will change it.

> > +	  is determined by a combination of page size and virtual address
> > +	  space size.
> > +
> > +config ARM64_VA_BITS_39
> > +	bool "39-bit"
> > +	depends on ARM64_4K_PAGES
> > +
> > +config ARM64_VA_BITS_42
> > +	bool "42-bit"
> > +	depends on ARM64_64K_PAGES
> > +
> > +endchoice
> > +
> > +config ARM64_VA_BITS
> > +	int
> > +	default 39 if ARM64_VA_BITS_39
> > +	default 42 if ARM64_VA_BITS_42
> > +
> > +config ARM64_2_LEVELS
> > +	def_bool y if ARM64_64K_PAGES && ARM64_VA_BITS_42
> > +
> > +config ARM64_3_LEVELS
> > +	def_bool y if ARM64_4K_PAGES && ARM64_VA_BITS_39
> > +
> >  config CPU_BIG_ENDIAN
> >         bool "Build big-endian kernel"
> >         help
> > diff --git a/arch/arm64/include/asm/memory.h
> > b/arch/arm64/include/asm/memory.h index e94f945..f6e7480 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -41,11 +41,7 @@
> >   * The module space lives between the addresses given by TASK_SIZE
> >   * and PAGE_OFFSET - it must be within 128MB of the kernel text.
> >   */
> > -#ifdef CONFIG_ARM64_64K_PAGES
> > -#define VA_BITS			(42)
> > -#else
> > -#define VA_BITS			(39)
> > -#endif
> > +#define VA_BITS			(CONFIG_ARM64_VA_BITS)
> >  #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
> >  #define MODULES_END		(PAGE_OFFSET)
> >  #define MODULES_VADDR		(MODULES_END - SZ_64M)
> > diff --git a/arch/arm64/include/asm/page.h
> > b/arch/arm64/include/asm/page.h index 46bf666..268e53d 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -33,7 +33,7 @@
> >
> >  #ifndef __ASSEMBLY__
> >
> > -#ifdef CONFIG_ARM64_64K_PAGES
> > +#ifdef CONFIG_ARM64_2_LEVELS
> >  #include <asm/pgtable-2level-types.h>  #else  #include
> > <asm/pgtable-3level-types.h> diff --git
> > a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
> > index 9bea6e7..4829837 100644
> > --- a/arch/arm64/include/asm/pgalloc.h
> > +++ b/arch/arm64/include/asm/pgalloc.h
> > @@ -26,7 +26,7 @@
> >
> >  #define check_pgt_cache()		do { } while (0)
> >
> > -#ifndef CONFIG_ARM64_64K_PAGES
> > +#ifndef CONFIG_ARM64_2_LEVELS
> >
> >  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned
> > long addr)  { @@ -44,7 +44,7 @@ static inline void pud_populate(struct
> > mm_struct *mm, pud_t *pud, pmd_t *pmd)
> >  	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));  }
> >
> > -#endif	/* CONFIG_ARM64_64K_PAGES */
> > +#endif	/* CONFIG_ARM64_2_LEVELS */
> >
> >  extern pgd_t *pgd_alloc(struct mm_struct *mm);  extern void
> > pgd_free(struct mm_struct *mm, pgd_t *pgd); diff --git
> > a/arch/arm64/include/asm/pgtable-hwdef.h
> > b/arch/arm64/include/asm/pgtable-hwdef.h
> > index 5fc8a66..9cd86c6 100644
> > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > @@ -16,7 +16,7 @@
> >  #ifndef __ASM_PGTABLE_HWDEF_H
> >  #define __ASM_PGTABLE_HWDEF_H
> >
> > -#ifdef CONFIG_ARM64_64K_PAGES
> > +#ifdef CONFIG_ARM64_2_LEVELS
> >  #include <asm/pgtable-2level-hwdef.h>  #else  #include
> > <asm/pgtable-3level-hwdef.h> diff --git
> > a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 90c811f..a64ce5e 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -47,7 +47,7 @@ extern void __pmd_error(const char *file, int line,
> > unsigned long val);  extern void __pgd_error(const char *file, int
> > line, unsigned long val);
> >
> >  #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
> > -#ifndef CONFIG_ARM64_64K_PAGES
> > +#ifndef CONFIG_ARM64_2_LEVELS
> >  #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
> >  #endif
> >  #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
> > @@ -320,7 +320,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
> >   */
> >  #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
> >
> > -#ifndef CONFIG_ARM64_64K_PAGES
> > +#ifndef CONFIG_ARM64_2_LEVELS
> >
> >  #define pud_none(pud)		(!pud_val(pud))
> >  #define pud_bad(pud)		(!(pud_val(pud) & 2))
> > @@ -342,7 +342,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
> >  	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);  }
> >
> > -#endif	/* CONFIG_ARM64_64K_PAGES */
> > +#endif	/* CONFIG_ARM64_2_LEVELS */
> >
> >  /* to find an entry in a page-table-directory */
> >  #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
> > @@ -353,7 +353,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
> >  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
> >
> >  /* Find an entry in the second-level page table.. */ -#ifndef
> > CONFIG_ARM64_64K_PAGES
> > +#ifndef CONFIG_ARM64_2_LEVELS
> >  #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
> >  static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)  {
> > diff --git a/arch/arm64/include/asm/tlb.h
> > b/arch/arm64/include/asm/tlb.h index 80e2c08..bc19101 100644
> > --- a/arch/arm64/include/asm/tlb.h
> > +++ b/arch/arm64/include/asm/tlb.h
> > @@ -91,7 +91,7 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
> >  	tlb_remove_page(tlb, pte);
> >  }
> >
> > -#ifndef CONFIG_ARM64_64K_PAGES
> > +#ifndef CONFIG_ARM64_2_LEVELS
> >  static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> >  				  unsigned long addr)
> >  {
> > --
> > 1.7.10.4
> >
> >
> Otherwise looks good,
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks!

Best Regards
Jungseok Lee

