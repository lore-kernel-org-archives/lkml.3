Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaJFO1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:27:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJFO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:27:49 -0400
Date: Mon, 6 Oct 2014 14:27:13 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: updated comments of CLONE_NEWNS
Message-ID: <20141006142713.GA26187@ubuntumail>
References: <1412587493-10547-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412587493-10547-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Yeah that'll be helpful to anyone new to these parts.  But, why the question mark,
should you drop that too?  Either way

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  include/uapi/linux/sched.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..db765b4 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -13,7 +13,7 @@
>  #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
>  #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
>  #define CLONE_THREAD	0x00010000	/* Same thread group? */
> -#define CLONE_NEWNS	0x00020000	/* New namespace group? */
> +#define CLONE_NEWNS	0x00020000	/* New mount namespace group? */
>  #define CLONE_SYSVSEM	0x00040000	/* share system V SEM_UNDO semantics */
>  #define CLONE_SETTLS	0x00080000	/* create a new TLS for the child */
>  #define CLONE_PARENT_SETTID	0x00100000	/* set the TID in the parent */
> -- 
> 1.9.0
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
