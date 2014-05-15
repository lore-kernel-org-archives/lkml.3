Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaEOMK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:10:57 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60919 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaEOMK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:10:56 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1397211951-20549-9-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-9-git-send-email-miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:10:55 +0200
Message-ID: <CAJfpegue5pcHrhVKW533iaWzaW4mcgThRjrxwK8a5KE_8v=mAQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] ia64: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Tony Luck <tony.luck@intel.com>

Tony,

I'll be sending a batch of patches with arch support for the renameat2
syscall to Linus next week.  If you'd like me to send this as well,
could you please ACK it?

Thanks,
Miklos


> ---
>  arch/ia64/include/asm/unistd.h      | 2 +-
>  arch/ia64/include/uapi/asm/unistd.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
> index ae763d8bf55a..fb13dc5e8f8c 100644
> --- a/arch/ia64/include/asm/unistd.h
> +++ b/arch/ia64/include/asm/unistd.h
> @@ -11,7 +11,7 @@
>
>
>
> -#define NR_syscalls                    314 /* length of syscall table */
> +#define NR_syscalls                    315 /* length of syscall table */
>
>  /*
>   * The following defines stop scripts/checksyscalls.sh from complaining about
> diff --git a/arch/ia64/include/uapi/asm/unistd.h b/arch/ia64/include/uapi/asm/unistd.h
> index 715e85f858de..7de0a2d65da4 100644
> --- a/arch/ia64/include/uapi/asm/unistd.h
> +++ b/arch/ia64/include/uapi/asm/unistd.h
> @@ -327,5 +327,6 @@
>  #define __NR_finit_module              1335
>  #define __NR_sched_setattr             1336
>  #define __NR_sched_getattr             1337
> +#define __NR_renameat2                 1338
>
>  #endif /* _UAPI_ASM_IA64_UNISTD_H */
> --
> 1.8.1.4
>
