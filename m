Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaFCSVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:21:48 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39331 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaFCSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:21:47 -0400
Date: Tue, 3 Jun 2014 20:21:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt, minor
 comment updates
Message-ID: <20140603182142.GA5097@gmail.com>
References: <20140601192520.GA14539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140601192520.GA14539@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Purely cosmetic, no changes in .o,
> 
> 1. As Jim pointed out arch_uprobe->def looks ambiguous, rename it to
>    ->dflt.
> 
> 2. Add the comment into default_post_xol_op() to explain "regs->sp +=".
> 
> 3. Remove the stale part of the comment in arch_uprobe_analyze_insn().
> 
> Suggested-by: Jim Keniston <jkenisto@us.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/include/asm/uprobes.h |    2 +-
>  arch/x86/kernel/uprobes.c      |   37 ++++++++++++++++++-------------------
>  2 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 7be3c07..b3d9442 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -52,7 +52,7 @@ struct arch_uprobe {
>  		struct {
>  			u8	fixups;
>  			u8	ilen;
> -		} 			def;
> +		} 			dflt;

Pls lts nt use slly abbrvtns, ok?

How about arch_uprobe->default?

Thanks,

	Ingo
