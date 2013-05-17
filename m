Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3EQC20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:28:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3EQC2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPjo2dQpYPpqZS8GC8UPNzB5HLURpYm6-g1FOBbSUjDyA@mail.gmail.com>
References: <CACVXFVPjo2dQpYPpqZS8GC8UPNzB5HLURpYm6-g1FOBbSUjDyA@mail.gmail.com>
Date: Fri, 17 May 2013 10:28:23 +0800
Message-ID: <CACVXFVPYsF3z6GajSeTSq6r0jbLrPWeGf9=0ckqC+uprF7wOiw@mail.gmail.com>
Subject: Re: [Bug] ARM 'perf' regression by commit a43cb95d5
From: Ming Lei <ming.lei@canonical.com>
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:16 AM, Ming Lei <ming.lei@canonical.com> wrote:
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index f219703..89bc3a4 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -225,7 +225,7 @@ void __show_regs(struct pt_regs *regs)
>         unsigned long flags;
>         char buf[64];
>
> -       show_regs_print_info(KERN_DEFAULT);
> +       //show_regs_print_info(KERN_DEFAULT);

Forget to mention, __show_regs() isn't run under both cases.

Thanks,
--
Ming Lei
