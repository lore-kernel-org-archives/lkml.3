Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaEGEW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:22:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaEGEW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:22:56 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-85-5369b51add5c
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
 <20140506104907.GB3066@lvm>
In-reply-to: <20140506104907.GB3066@lvm>
Subject: Re: [PATCH v5 5/6] arm64: mm: Implement 4 levels of translation tables
Date: Wed, 07 May 2014 13:22:50 +0900
Message-id: <001c01cf69ac$01be8bf0$053ba3d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLeVLXF14hWIlib+IwkCJqi5P6lawF9kNq2mQq+kFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zga7U1sxgg1lTDCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	acdJ5oInPhWd3dPYGhh/WnUxcnJICJhIdK/tZ4SwxSQu3FvP1sXIxSEksIxRYsPNPmaYoqs3
	TjNCJKYzSsx7ewTK+cMoMX/GZnaQKjYBTYlHd3vAbBGgjs/35oGNYhZ4yyTxe8c0sISQQLjE
	+WeNrCA2p4CGxMl/a8B2Cwv4SyxY/JIJxGYRUJXo+30fbDWvgKXEy807GCFsQYkfk++xgNjM
	AloSm7c1sULY8hKb17yFOlVBYsfZ14wQR1hJzDs/gw2iRkRi34t3YFdLCCzkkFg4ZRLUMgGJ
	b5MPAQ3lAErISmw6ADVHUuLgihssExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IkO9
	4sTc4tK8dL3k/NxNjJA00LuD8fYB60OMyUDrJzJLiSbnA9NIXkm8obGZkYWpiamxkbmlGWnC
	SuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw3viwP1rm/yvhh+szzMQWrJeeI2BV
	uezya1XeMl3JbxwVsc+uzXbZxVbbpuPbVnJ/L/uKtXwlCeVnFv7Y2pecahcybcJbjmseCmcZ
	Q9hdqvdGfuMSYazbn3IrzuLZ/J0Totcesd/yfUVd/wPGFu8E9U7b7UWJvx0L7qX07d6hvaU+
	XLCJ5c9bJZbijERDLeai4kQAffivXBkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQV2prZnBBmsfaFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjKcdJ5kLnvhUdHZPY2tg/GnVxcjJISFgInH1xmlGCFtM
	4sK99WxdjFwcQgLTGSXmvT3CCOH8YZSYP2MzO0gVm4CmxKO7PWC2CFD353vzwDqYBd4ySfze
	MQ0sISQQLnH+WSMriM0poCFx8t8asBXCAv4SCxa/ZAKxWQRUJfp+32cGsXkFLCVebt7BCGEL
	SvyYfI8FxGYW0JLYvK2JFcKWl9i85i0zxKkKEjvOvmaEOMJKYt75GWwQNSIS+168Y5zAKDQL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk8wzqR2MKxssDjEK
	cDAq8fBavM0IFmJNLCuuzD3EKMHBrCTCu2htZrAQb0piZVVqUX58UWlOavEhxmSgTycyS4km
	5wMTYF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MMq5ZTT8
	vWy11FPmcd0pC6GT4Z+Yle9MsWE8VuhzwnmLQGyNcNm/GOWIUywxOQsuzTIMPXkm6nFy4eIN
	z77nNyVucJkxb+ZC2QnhU1Z2XVL+svLc3jNbS95kJd6J4l8QUHo9/4ac1rRzYjE7Hh2MM42d
	OdGQaZbk9BhT/YgdxW0vr3yY6+N9P1qJpTgj0VCLuag4EQCJOkx0dgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2014 7:49 PM, Christoffer Dall wrote:
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
> 
> Who recommends this then?  This paragraph just confuses me.

It is a paraphrase of Catalin's comment:
"I agree, we should only enable 4-levels of page table if we have close
to 512GB of RAM or the range is too sparse but I would actually push
back on the hardware guys to keep it tighter."

The above message comes from the discussion on 4 levels.
http://www.spinics.net/linux/lists/arm-kernel/msg319055.html

> >
> > References
> > ----------
> > [1]: Principles of ARM Memory Maps, White Paper, Issue C
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm64/Kconfig                     |    8 ++++++
> >  arch/arm64/include/asm/memblock.h      |    6 +++++
> >  arch/arm64/include/asm/page.h          |    4 ++-
> >  arch/arm64/include/asm/pgalloc.h       |   20 ++++++++++++++
> >  arch/arm64/include/asm/pgtable-hwdef.h |    6 +++--
> >  arch/arm64/include/asm/pgtable.h       |   45 +++++++++++++++++++++++++++++++
> >  arch/arm64/include/asm/tlb.h           |    9 +++++++
> >  arch/arm64/kernel/head.S               |   46 +++++++++++++++++++++++++-------
> >  arch/arm64/kernel/traps.c              |    5 ++++
> >  arch/arm64/mm/fault.c                  |    1 +
> >  arch/arm64/mm/mmu.c                    |   16 ++++++++---
> >  11 files changed, 150 insertions(+), 16 deletions(-)
> >

[ ... ]

> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S index
> > 0fd5650..03ec424 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> > @@ -37,8 +37,9 @@
> >
> >  /*
> >   * swapper_pg_dir is the virtual address of the initial page table.
> > We place
> > - * the page tables 3 * PAGE_SIZE below KERNEL_RAM_VADDR. The
> > idmap_pg_dir has
> > - * 2 pages and is placed below swapper_pg_dir.
> > + * the page tables 3 * PAGE_SIZE (2 or 3 levels) or 4 * PAGE_SIZE (4
> > + levels)
> > + * below KERNEL_RAM_VADDR. The idmap_pg_dir has 2 pages (2 or 3
> > + levels) or
> > + * 3 pages (4 levels) and is placed below swapper_pg_dir.
> >   */
> >  #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
> >
> > @@ -46,8 +47,13 @@
> >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> > +#else
> >  #define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> >  #define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > +#endif
> >
> >  	.globl	swapper_pg_dir
> >  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> > @@ -370,16 +376,38 @@ ENDPROC(__calc_phys_offset)
> >  	.quad	PAGE_OFFSET
> >
> >  /*
> > + * Macro to populate the PUD for the corresponding block entry in the
> > + next
> > + * level (tbl) for the given virtual address in case of 4levels.
> > + */
> 
> With the relatively high number of parameters to this macro, I feel it would be helpful to state in
> the comment that this actually modifies \tbl and returns a value in \pud.

Okay, I will add it.

> > +	.macro	create_pud_entry, pgd, tbl, virt, pud, tmp1, tmp2
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	add	\tbl, \tbl, #PAGE_SIZE		// bump tbl 1 page up.
> > +						// to make room for pud
> > +	add	\pud, \pgd, #PAGE_SIZE		// pgd points to pud which
> > +						// follows pgd
> > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > +	orr	\tmp2, \tbl, #3			// PUD entry table type
> > +	str	\tmp2, [\pud, \tmp1, lsl #3]
> > +#else
> > +	mov	\pud, \tbl
> > +#endif
> > +	.endm
> > +
> > +/*
> >   * Macro to populate the PGD for the corresponding block entry in the next
> >   * level (tbl) for the given virtual address.
> 
> Then this should be changed to be: "populate the PGD (and possibly PUD)"

Okay. I will revise it.

> >   *
> > - * Preserves:	pgd, tbl, virt
> > - * Corrupts:	tmp1, tmp2
> > + * Preserves:	pgd, virt
> > + * Corrupts:	tmp1, tmp2, tmp3
> > + * Returns:	tbl -> page where block mappings can be placed
> > + *	(changed to make room for pud with 4levels, preserved otherwise)
> >   */
> > -	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2
> > +	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2, tmp3
> > +	create_pud_entry \pgd, \tbl, \virt, \tmp3, \tmp1, \tmp2
> >  	lsr	\tmp1, \virt, #PGDIR_SHIFT
> >  	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
> > -	orr	\tmp2, \tbl, #3			// PGD entry table type
> > +	orr	\tmp2, \tmp3, #3		// PGD entry table type
> >  	str	\tmp2, [\pgd, \tmp1, lsl #3]
> >  	.endm
> >
> > @@ -444,7 +472,7 @@ __create_page_tables:
> >  	add	x0, x25, #PAGE_SIZE		// section table address
> >  	ldr	x3, =KERNEL_START
> >  	add	x3, x3, x28			// __pa(KERNEL_START)
> > -	create_pgd_entry x25, x0, x3, x5, x6
> > +	create_pgd_entry x25, x0, x3, x1, x5, x6
> >  	ldr	x6, =KERNEL_END
> >  	mov	x5, x3				// __pa(KERNEL_START)
> >  	add	x6, x6, x28			// __pa(KERNEL_END)
> > @@ -455,7 +483,7 @@ __create_page_tables:
> >  	 */
> >  	add	x0, x26, #PAGE_SIZE		// section table address
> >  	mov	x5, #PAGE_OFFSET
> > -	create_pgd_entry x26, x0, x5, x3, x6
> > +	create_pgd_entry x26, x0, x5, x1, x3, x6
> >  	ldr	x6, =KERNEL_END
> >  	mov	x3, x24				// phys offset
> >  	create_block_map x0, x7, x3, x5, x6
> > @@ -481,7 +509,7 @@ __create_page_tables:
> >  	 */
> >  	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
> >  	add	x0, x26, #2 * PAGE_SIZE		// section table address
> > -	create_pgd_entry x26, x0, x5, x6, x7
> > +	create_pgd_entry x26, x0, x5, x1, x6, x7
> >
> >  	/*
> >  	 * Since the page tables have been populated with non-cacheable diff
> > --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c index
> > 268ce96..237757d 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -336,6 +336,11 @@ void __pmd_error(const char *file, int line, unsigned long val)
> >  	pr_crit("%s:%d: bad pmd %016lx.\n", file, line, val);  }
> >
> > +void __pud_error(const char *file, int line, unsigned long val) {
> > +	pr_crit("%s:%d: bad pud %016lx.\n", file, line, val); }
> > +
> >  void __pgd_error(const char *file, int line, unsigned long val)  {
> >  	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val); diff --git
> > a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c index c23751b..ed4a343
> > 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -61,6 +61,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
> >  			break;
> >
> >  		pud = pud_offset(pgd, addr);
> > +		printk(", *pud=%016llx", pud_val(*pud));
> >  		if (pud_none(*pud) || pud_bad(*pud))
> >  			break;
> >
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c index
> > 6b7e895..4d29332 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -32,6 +32,7 @@
> >  #include <asm/setup.h>
> >  #include <asm/sizes.h>
> >  #include <asm/tlb.h>
> > +#include <asm/memblock.h>
> >  #include <asm/mmu_context.h>
> >
> >  #include "mm.h"
> > @@ -222,9 +223,15 @@ static void __init alloc_init_pmd(pud_t *pud,
> > unsigned long addr,  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> >  				  unsigned long end, unsigned long phys)  {
> > -	pud_t *pud = pud_offset(pgd, addr);
> > +	pud_t *pud;
> >  	unsigned long next;
> >
> > +	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
> > +		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
> > +		pgd_populate(&init_mm, pgd, pud);
> > +	}
> > +
> > +	pud = pud_offset(pgd, addr);
> >  	do {
> >  		next = pud_addr_end(addr, end);
> >  		alloc_init_pmd(pud, addr, next, phys); @@ -271,10 +278,11 @@ static
> > void __init map_mem(void)
> >  	 * memory addressable from the initial direct kernel mapping.
> >  	 *
> >  	 * The initial direct kernel mapping, located at swapper_pg_dir,
> > -	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (which must be
> > -	 * aligned to 2MB as per Documentation/arm64/booting.txt).
> > +	 * gives us PGDIR_SIZE (2 and 3 levels) or PUD_SIZE (4 levels) memory
> > +	 * starting from PHYS_OFFSET (which must be aligned to 2MB as per
> > +	 * Documentation/arm64/booting.txt).
> >  	 */
> > -	limit = PHYS_OFFSET + PGDIR_SIZE;
> > +	limit = PHYS_OFFSET + MEMBLOCK_INITIAL_LIMIT;
> >  	memblock_set_current_limit(limit);
> >
> >  	/* map all the memory banks */
> > --
> > 1.7.10.4
> >
> >
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks for comment and review!

- Jungseok Lee

