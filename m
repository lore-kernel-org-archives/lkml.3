Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaDWLrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:47:00 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38632 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaDWLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:46:58 -0400
MIME-Version: 1.0
X-Originating-IP: [217.156.156.35]
In-Reply-To: <1397211951-20549-16-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-16-git-send-email-miklos@szeredi.hu>
Date: Wed, 23 Apr 2014 12:46:57 +0100
X-Google-Sender-Auth: bhNWmPW_chDCEBpwyGi8ZbKXZoc
Message-ID: <CAAG0J9_4e4S4JOZn4-v=9=vcW976Jq-3aYTNCZzc0KQ5J5-5Mg@mail.gmail.com>
Subject: Re: [PATCH 15/15] asm-generic: add renameat2 syscall
From: James Hogan <james.hogan@imgtec.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On 11 April 2014 11:25, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: James Hogan <james.hogan@imgtec.com> [metag]

Thanks
James

> ---
>  include/uapi/asm-generic/unistd.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 6db66783d268..333640608087 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -697,9 +697,11 @@ __SYSCALL(__NR_finit_module, sys_finit_module)
>  __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
>  #define __NR_sched_getattr 275
>  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
> +#define __NR_renameat2 276
> +__SYSCALL(__NR_renameat2, sys_renameat2)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 276
> +#define __NR_syscalls 277
>
>  /*
>   * All syscalls below here should go away really,
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
