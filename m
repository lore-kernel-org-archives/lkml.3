Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3KFKt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:49:27 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46663 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab3KFKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:49:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131106103403.GB21074@mudshark.cambridge.arm.com>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
	<20131105224217.GC20167@shutemov.name>
	<20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
	<20131105231310.GE20167@shutemov.name>
	<20131106103403.GB21074@mudshark.cambridge.arm.com>
Date: Wed, 6 Nov 2013 11:49:23 +0100
X-Google-Sender-Auth: 6woCX4KtBhKEPRAbDUew2qwfdaw
Message-ID: <CAMuHMdWyrsyrf8N0ytSDfe0y1oxGrfFCZCmV-9Mm11yuyTs=5g@mail.gmail.com>
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:34 AM, Will Deacon <will.deacon@arm.com> wrote:
> FWIW: if the architecture selects ARCH_USE_CMPXCHG_LOCKREF, then a spinlock_t
> is 32-bit (assuming that unsigned int is also 32-bit).

Linux already assumes (unsigned) int is 32-bit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
