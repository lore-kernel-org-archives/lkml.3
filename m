Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaEOMQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:16:41 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36209 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaEOMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:16:40 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1397211951-20549-11-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-11-git-send-email-miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:16:39 +0200
Message-ID: <CAJfpeguPz23Sgj3FDKbKn_7UdqDfj4YNZ2yr3ydRi-KO-GX+7w@mail.gmail.com>
Subject: Re: [PATCH 10/15] powerpc: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Ben,

I'll be sending a batch of patches with arch support for the renameat2
syscall to Linus next week.  If you'd like me to send this as well,
could you please ACK it?

Thanks,
Miklos

> ---
>  arch/powerpc/include/asm/systbl.h      | 1 +
>  arch/powerpc/include/asm/unistd.h      | 2 +-
>  arch/powerpc/include/uapi/asm/unistd.h | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
> index 3ddf70276706..ea4dc3a89c1f 100644
> --- a/arch/powerpc/include/asm/systbl.h
> +++ b/arch/powerpc/include/asm/systbl.h
> @@ -361,3 +361,4 @@ SYSCALL(finit_module)
>  SYSCALL(ni_syscall) /* sys_kcmp */
>  SYSCALL_SPU(sched_setattr)
>  SYSCALL_SPU(sched_getattr)
> +SYSCALL_SPU(renameat2)
> diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
> index 4494f029b632..9b892bbd9d84 100644
> --- a/arch/powerpc/include/asm/unistd.h
> +++ b/arch/powerpc/include/asm/unistd.h
> @@ -12,7 +12,7 @@
>  #include <uapi/asm/unistd.h>
>
>
> -#define __NR_syscalls          357
> +#define __NR_syscalls          358
>
>  #define __NR__exit __NR_exit
>  #define NR_syscalls    __NR_syscalls
> diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
> index 881bf2e2560d..2d526f7b48da 100644
> --- a/arch/powerpc/include/uapi/asm/unistd.h
> +++ b/arch/powerpc/include/uapi/asm/unistd.h
> @@ -379,5 +379,6 @@
>  #define __NR_kcmp              354
>  #define __NR_sched_setattr     355
>  #define __NR_sched_getattr     356
> +#define __NR_renameat2         357
>
>  #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
> --
> 1.8.1.4
>
