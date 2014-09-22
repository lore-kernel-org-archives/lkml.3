Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaIVJKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:10:37 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43774 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaIVJKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <1411376728-15807-1-git-send-email-geert@linux-m68k.org>
References: <1411376728-15807-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 22 Sep 2014 11:10:35 +0200
X-Google-Sender-Auth: LjJkIat39_-fqOjRR6zyiyytQVo
Message-ID: <CAMuHMdVwOYB0HzYY_Uu+kKapC3eHSoV-=t1QHLFzgcGX2UOYoQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:05 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.17-rc5[1]  to v3.17-rc4[3], the summaries are:
>   - build errors: +13/-3

  + /scratch/kisskb/src/arch/powerpc/kernel/iommu.c: error:
'fail_iommu_bus_notifier' defined but not used
[-Werror=unused-variable]:  => 149:30
  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PAGES_PER_SECTION' undeclared (first use in this function):  =>
1918:46, 1810:46, 1152:18
  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PAGE_SECTION_MASK' undeclared (first use in this function):  =>
1151:20
  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PFN_SECTION_SHIFT' undeclared (first use in this function):  =>
1379:31
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function '__nr_to_section'
[-Werror=implicit-function-declaration]:  => 1815:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'find_memory_block_hinted'
[-Werror=implicit-function-declaration]:  => 1822:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'pfn_to_section_nr'
[-Werror=implicit-function-declaration]:  => 1811:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'present_section_nr'
[-Werror=implicit-function-declaration]:  => 1812:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'section_nr_to_pfn'
[-Werror=implicit-function-declaration]:  => 1847:3

powerpc-randconfig

+ a few new R_PPC64_REL24.

> [1] http://kisskb.ellerman.id.au/kisskb/head/7872/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7854/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
