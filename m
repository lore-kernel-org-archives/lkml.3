Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaKJHoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:44:37 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54001 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaKJHof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:44:35 -0500
Date: Mon, 10 Nov 2014 08:44:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: john_gong <john_gong@yeah.net>
Cc: pbonzini@redhat.com,
        "Gleb Natapov <gleb@kernel.org> Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: typo of the comment
Message-ID: <20141110074430.GA10177@gmail.com>
References: <545D8968.4080004@yeah.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545D8968.4080004@yeah.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john_gong <john_gong@yeah.net> wrote:

> hi Paolo,
> i find a typo of the comment.
> 
> 
> From 09d5df31f0930e8e3eb10ad60a3debc53d6ce992 Mon Sep 17 00:00:00 2001
> From: john_gong <john_gong@yeah.net>
> Date: Fri, 7 Nov 2014 07:32:17 +0800
> Subject: [PATCH] modify a typo of the comment
> 
> Signed-off-by: john_gong <john_gong@yeah.net>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ef432f8..42bb2c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -214,7 +214,7 @@ void kvm_define_shared_msr(unsigned slot, u32 msr)
>      if (slot >= shared_msrs_global.nr)
>          shared_msrs_global.nr = slot + 1;
>      shared_msrs_global.msrs[slot] = msr;
> -    /* we need ensured the shared_msr_global have been updated */
> +    /* we need ensured the shared_msrs_global have been updated */
>      smp_wmb();

That's not the only typo in that sentence though.

Thanks,

	Ingo
