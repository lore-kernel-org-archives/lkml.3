Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaDKLYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:24:22 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:52395 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaDKLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:24:18 -0400
Date: Fri, 11 Apr 2014 13:24:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 11/15] s390: NR_syscalls fix
Message-ID: <20140411132412.2ef89a3b@mschwide>
In-Reply-To: <1397211951-20549-12-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-12-git-send-email-miklos@szeredi.hu>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041111-5024-0000-0000-00000976173D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 12:25:47 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  arch/s390/include/uapi/asm/unistd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
> index 5eb5c9ddb120..57194268fe63 100644
> --- a/arch/s390/include/uapi/asm/unistd.h
> +++ b/arch/s390/include/uapi/asm/unistd.h
> @@ -282,7 +282,7 @@
>  #define __NR_finit_module	344
>  #define __NR_sched_setattr	345
>  #define __NR_sched_getattr	346
> -#define NR_syscalls 345
> +#define NR_syscalls 347
> 
>  /* 
>   * There are some system calls that are not present on 64 bit, some

Is this patch part of a patch series that does upstream directly?
I am asking because Heiko already created a patch for this and we have
added it to the linux-s390:fixes branch for upstream integration.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

