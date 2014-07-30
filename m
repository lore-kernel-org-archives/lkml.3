Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaG3GmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:42:05 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43350 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaG3GmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUyif5JS9OdiamHhf+r5oeTRdd7Gzd6-rBUyamnNQ6C8A@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-6-git-send-email-lftan@altera.com>
	<CAMuHMdUyif5JS9OdiamHhf+r5oeTRdd7Gzd6-rBUyamnNQ6C8A@mail.gmail.com>
Date: Wed, 30 Jul 2014 14:42:00 +0800
X-Google-Sender-Auth: _yKJ2sN2_KrZLEPHhQEwR9M5L_c
Message-ID: <CAFiDJ5_9a7pr+16gjV5-cA_Ruoz1LDMKivFemNiOf_Me4bLEUg@mail.gmail.com>
Subject: Re: [PATCH v2 05/29] nios2: Memory management
From: Ley Foon Tan <lftan@altera.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:59 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Jul 15, 2014 at 10:45 AM, Ley Foon Tan <lftan@altera.com> wrote:
>> --- /dev/null
>> +++ b/arch/nios2/include/asm/mmu.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
>> + * Copyright (C) 2004 Microtronix Datacom Ltd.
>> + *
>> + * Taken from m68knommu.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License. See the file "COPYING" in the main directory of this archive
>> + * for more details.
>> + */
>> +
>> +#ifndef _ASM_NIOS2_MMU_H
>> +#define _ASM_NIOS2_MMU_H
>> +
>> +/* Default "unsigned long" context */
>> +typedef unsigned long mm_context_t;
>> +
>> +#endif /* _ASM_NIOS2_MMU_H */
>
> Any chance you can use mmu.h from asm-generic instead?
> It uses a struct with a single "unsigned long end_brk" member (unless
> CONFIG_BINFMT_ELF_FDPIC is defined).
>From asm-generic/mmu.h, it is for nommu implementations.
So, I will keep this as it is now.

Thanks.

Regards
Ley Foon
