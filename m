Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaEWIlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:41:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17939 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751472AbaEWIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:41:34 -0400
Date: Fri, 23 May 2014 09:41:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: linux-next: manual merge of the tip tree with the arm64 tree
Message-ID: <20140523084118.GA9252@arm.com>
References: <20140523162844.05e6ac65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523162844.05e6ac65@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 07:28:44AM +0100, Stephen Rothwell wrote:
> diff --cc arch/arm64/include/asm/thread_info.h
> index 9c086c63f911,7b8e3a2a00fb..000000000000
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@@ -103,12 -99,7 +102,11 @@@ static inline struct thread_info *curre
>   #define TIF_SIGPENDING		0
>   #define TIF_NEED_RESCHED	1
>   #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>  +#define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
>   #define TIF_SYSCALL_TRACE	8
>  +#define TIF_SYSCALL_AUDIT	9
>  +#define TIF_SYSCALL_TRACEPOINT	10
>  +#define TIF_SECCOMP		11
> - #define TIF_POLLING_NRFLAG	16
>   #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
>   #define TIF_FREEZE		19
>   #define TIF_RESTORE_SIGMASK	20

It looks fine, thanks.

-- 
Catalin
