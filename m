Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaL2NR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:17:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaL2NRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:17:25 -0500
Date: Mon, 29 Dec 2014 14:16:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 1/1 RESEND] ptrace: remove linux/compat.h inclusion
	under CONFIG_COMPAT
Message-ID: <20141229131639.GA23323@redhat.com>
References: <1419848439-9596-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419848439-9596-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Fabian Frederick wrote:
> Commit 84c751bd4aeb
> ("ptrace: add ability to retrieve signals without removing from a queue (v4)")
> includes <linux/compat.h> globally in ptrace.c
> 
> This patch removes inclusion under if defined CONFIG_COMPAT.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Oleg Nesterov <oleg@redhat.com>



> ---
>  kernel/ptrace.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 1eb9d90..227fec3 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1077,7 +1077,6 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
>  }
>  
>  #if defined CONFIG_COMPAT
> -#include <linux/compat.h>
>  
>  int compat_ptrace_request(struct task_struct *child, compat_long_t request,
>  			  compat_ulong_t addr, compat_ulong_t data)
> -- 
> 2.1.0
> 

