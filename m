Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaKDJDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:03:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKDJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:03:24 -0500
Date: Tue, 4 Nov 2014 09:03:08 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <trivial@kernel.org>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: updated comments of CLONE_NEWUTS and CLONE_NEWIPC
Message-ID: <20141104090308.GA15355@ubuntumail>
References: <1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> Remove question mark:
> s/New utsname group?/New utsname namespace
> 
> Unified style for IPC:
> s/New ipcs/New ipc namespace
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  include/uapi/linux/sched.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index b932be9..cc89dde 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -23,8 +23,8 @@
>  #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
>  /* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
>     and is now available for re-use. */
> -#define CLONE_NEWUTS		0x04000000	/* New utsname group? */
> -#define CLONE_NEWIPC		0x08000000	/* New ipcs */
> +#define CLONE_NEWUTS		0x04000000	/* New utsname namespace */
> +#define CLONE_NEWIPC		0x08000000	/* New ipc namespace */
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
>  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
> -- 
> 1.9.3
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
