Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaGZPqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:46:32 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50621 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaGZPqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <1406389175-9745-1-git-send-email-geert@linux-m68k.org>
References: <1406389175-9745-1-git-send-email-geert@linux-m68k.org>
Date: Sat, 26 Jul 2014 17:46:28 +0200
X-Google-Sender-Auth: T-21-c16_84U0y6tSX8NFxV02Ew
Message-ID: <CAMuHMdWM_Nbpj9nv6SctPcB0ygE0wzx=LpS4OFgq8ES9ZHcSBg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 5:39 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc5[1]  to v3.16-rc4[3], the summaries are:
>   - build errors: +14/-11

  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PAGES_PER_SECTION' undeclared (first use in this function):  =>
1779:46, 1887:46, 1149:18
  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PAGE_SECTION_MASK' undeclared (first use in this function):  =>
1148:20
  + /scratch/kisskb/src/mm/memory_hotplug.c: error:
'PFN_SECTION_SHIFT' undeclared (first use in this function):  =>
1348:31
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function '__nr_to_section'
[-Werror=implicit-function-declaration]:  => 1784:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'find_memory_block_hinted'
[-Werror=implicit-function-declaration]:  => 1791:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'pfn_to_section_nr'
[-Werror=implicit-function-declaration]:  => 1780:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'present_section_nr'
[-Werror=implicit-function-declaration]:  => 1781:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit
declaration of function 'section_nr_to_pfn'
[-Werror=implicit-function-declaration]:  => 1816:3

powerpc-randconfig

(ignoring a few more R_PPC64_REL24 truncated relocations in
powerpc-allyesconfig)

> [1] http://kisskb.ellerman.id.au/kisskb/head/7665/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7639/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
