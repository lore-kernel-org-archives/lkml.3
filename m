Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaD3C34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:29:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaD3C3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:29:49 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-da-53606010a2ef
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
References: <000601cf6367$cffab890$6ff029b0$@samsung.com>
 <20140429170404.GA32121@localhost>
In-reply-to: <20140429170404.GA32121@localhost>
Subject: Re: [PATCH v4 6/7] arm64: mm: Implement 4 levels of translation tables
Date: Wed, 30 Apr 2014 11:29:35 +0900
Message-id: <007b01cf641c$07357700$15a06500$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQHiB+TjvJiFdX/jU5AjaCCyaHe+HwJU+EW2mvF/tFA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zga5AQkKwweppvBZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWx
	bvtrtoInPBVHez4zNzC+5Oxi5OSQEDCRmLzuADuELSZx4d56ti5GLg4hgWWMEq1z57HCFF2a
	cIAFIrGIUeLy0X3MEM4fRomjtw6DVbEJaEo8utsDNkpEQF9i8ZUbrCBFzAIdzBJLny5j7GLk
	AOqIk5h+0wekhhOoZuHCfUwgtrCAv8SBA6uYQWwWAVWJmW/nM4LYvAKWEp3LtjJB2IISPybf
	YwGxmQW0JNbvPM4EYctLbF7zlhniUgWJHWdfM0LERST2vXgHtlZEwEri4j1FiJKlHBLvp/lB
	rBKQ+Db5EAtIiYSArMSmA1BTJCUOrrjBMoFRYhaSxbOQLJ6FZPEsJMsWMLKsYhRNLUguKE5K
	LzLRK07MLS7NS9dLzs/dxAhJABN2MN47YH2IMRlo/URmKdHkfGACySuJNzQ2M7IwNTE1NjK3
	NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxmniCq/+l1gdX/60yu/HuUe2
	yRvXCk999un0iw+1h2p/WFsezHhgO/vjbU1eJU2Wvh2HIuZnPt55VSVi3yannipr8fy5B8/Y
	M5/55LZz7/zFfz6cYlwdzxXYwnFG4amxdcdPFeZ9/4r28O+R3ij8fFv89ACP45kCP2Y8sWcS
	3pPGKcAq2RpTdE2JpTgj0VCLuag4EQDmOgw4FgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAV2BhIRgg8M/2S3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxrrtr9kKnvBUHO35zNzA+JKzi5GTQ0LAROLShAMsELaY
	xIV769m6GLk4hAQWMUpcPrqPGcL5wyhx9NZhVpAqNgFNiUd3e9hBbBEBfYnFV26wghQxC3Qw
	Syx9uoyxi5EDqCNOYvpNH5AaTqCahQv3MYHYwgL+EgcOrGIGsVkEVCVmvp3PCGLzClhKdC7b
	ygRhC0r8mHwP7CJmAS2J9TuPM0HY8hKb17xlhrhUQWLH2deMEHERiX0v3oGtFRGwkrh4T3EC
	o9AsJJNmIZk0C8mkWUi6FzCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITjDPpHcwrmqw
	OMQowMGoxMMrsDU+WIg1say4MvcQowQHs5IIL3NAQrAQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wOTX15JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MPo6
	+5+ed0H0ZdnaSmt90ddtT5/pcr5wvPN08+wF6WmaU/fe95vP/SbWoMNJ9mnq/E/Vp2MP1FU/
	kfzoW/WHX1xzteSOXSsnf1Dv7q88FiuboLv1D4/GFP84wwntZwsdPhm7Vjw/6javZPs0xtNv
	Oe9tkDF3Cpi/zOv5x9yb+StWnk5TS2g/U6jEUpyRaKjFXFScCAACloHWdAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 2:04 AM, Catalin Marinas wrote:
> On Tue, Apr 29, 2014 at 05:59:33AM +0100, Jungseok Lee wrote:
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
> >  #define KERNEL_RAM_VADDR       (PAGE_OFFSET + TEXT_OFFSET)
> >
> > @@ -46,8 +47,13 @@
> >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +#define SWAPPER_DIR_SIZE       (4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE         (3 * PAGE_SIZE)
> > +#else
> >  #define SWAPPER_DIR_SIZE       (3 * PAGE_SIZE)
> >  #define IDMAP_DIR_SIZE         (2 * PAGE_SIZE)
> > +#endif
> 
> Mark Rutland was doing some clean-up of this code to no longer place swapper_pg_dir and idmap_pg_dir
> below the kernel image. I'm not sure whether the patches ended up on the list yet (not a problem for
> now, just a slight change for your patches).

I don't see those patches in the mailing list yet.
I will keep it in mind. Thanks.

Best Regards
Jungseok Lee

