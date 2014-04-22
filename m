Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbaDVQ6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:58:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:49142 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932504AbaDVQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:58:51 -0400
Date: Tue, 22 Apr 2014 17:58:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 04/15] arm64: __NR_compat_syscalls fix
Message-ID: <20140422165814.GH10224@arm.com>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
 <1397211951-20549-5-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397211951-20549-5-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:25:40AM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/unistd32.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> index bb8eb8a78e67..faa0e1ce59df 100644
> --- a/arch/arm64/include/asm/unistd32.h
> +++ b/arch/arm64/include/asm/unistd32.h
> @@ -404,7 +404,7 @@ __SYSCALL(379, sys_finit_module)
>  __SYSCALL(380, sys_sched_setattr)
>  __SYSCALL(381, sys_sched_getattr)
>  
> -#define __NR_compat_syscalls		379
> +#define __NR_compat_syscalls		382

I picked up this patch, together with a Cc: stable and longer comment.

What's your plan with the other patches? Do you submit them as a series
or would like the arch maintainers to pick them up?

Thanks.

-- 
Catalin
