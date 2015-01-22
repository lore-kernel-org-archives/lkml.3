Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbbAVVma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:42:30 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:47146 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbbAVVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie>
References: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie>
Date: Thu, 22 Jan 2015 23:42:27 +0200
Message-ID: <CAHp75Vdqa_+-XdjpTUQwS8Ut6XxjQvbtGDuHmSnX-bO3joSbUw@mail.gmail.com>
Subject: Re: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:53 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:

[]

> Since Intel-CE, Intel-Mid and Intel-Quark are all 32-bit uniprocessor

I can hardly tell that Intel MID is UP systems.

No dashes, please :-)

Otherwise

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> systems with an IO-APIC re-enabling IO-APIC for 32-bit x86 is required.
>
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ba397bd..b36a7bd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -857,7 +857,7 @@ source "kernel/Kconfig.preempt"
>
>  config X86_UP_APIC
>         bool "Local APIC support on uniprocessors"
> -       depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
> +       depends on X86_32 && !SMP && !X86_32_NON_STANDARD
>         ---help---
>           A local APIC (Advanced Programmable Interrupt Controller) is an
>           integrated interrupt controller in the CPU. If you have a single-CPU
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
