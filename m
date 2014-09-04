Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaIDSKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:10:05 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:38665 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaIDSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140904134223.GB3312@redhat.com>
References: <20140904134135.GA3309@redhat.com> <20140904134223.GB3312@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Sep 2014 11:09:42 -0700
Message-ID: <CALCETrXG6_EcJCnh1-=DOjDt8fKXDWj2YAWLYwF9LG-2FaJktg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, lib/Makefile: remove the unnecessary "+= thunk_64.o"
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 6:42 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Trivial. We have "lib-y += thunk_$(BITS).o" at the start, no need
> to add thunk_64.o if !CONFIG_X86_32.
>

Acked-by: Andy Lutomirski <luto@amacapital.net>

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/lib/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 4d4f96a..66127b9 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -39,7 +39,7 @@ endif
>  else
>          obj-y += iomap_copy_64.o
>          lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
> -        lib-y += thunk_64.o clear_page_64.o copy_page_64.o
> +        lib-y += clear_page_64.o copy_page_64.o
>          lib-y += memmove_64.o memset_64.o
>          lib-y += copy_user_64.o copy_user_nocache_64.o
>         lib-y += cmpxchg16b_emu.o
> --
> 1.5.5.1
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
