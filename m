Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaEOMZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:25:02 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:50594 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaEOMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:25:00 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1397211951-20549-15-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-15-git-send-email-miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:25:00 +0200
Message-ID: <CAJfpegt4OdpZfaLjRjkLS27y_=kUeUpowHmbb_7TicsLpzYyGg@mail.gmail.com>
Subject: Re: [PATCH 14/15] xtensa: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: Chris Zankel <chris@zankel.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Chris Zankel <chris@zankel.net>

Chris,

I'll be sending a batch of patches with arch support for the renameat2
syscall to Linus next week.  If you'd like me to send this as well,
could you please ACK it?

Thanks,
Miklos

> ---
>  arch/xtensa/include/uapi/asm/unistd.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
> index b9395529f02d..8883fc877c5c 100644
> --- a/arch/xtensa/include/uapi/asm/unistd.h
> +++ b/arch/xtensa/include/uapi/asm/unistd.h
> @@ -739,7 +739,10 @@ __SYSCALL(334, sys_sched_setattr, 2)
>  #define __NR_sched_getattr                     335
>  __SYSCALL(335, sys_sched_getattr, 3)
>
> -#define __NR_syscall_count                     336
> +#define __NR_renameat2                         336
> +__SYSCALL(336, sys_renameat2, 5)
> +
> +#define __NR_syscall_count                     337
>
>  /*
>   * sysxtensa syscall handler
> --
> 1.8.1.4
>
