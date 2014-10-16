Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaJPQIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:08:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:49733
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:08:17 -0400
Date: Thu, 16 Oct 2014 18:08:15 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv1 2/8] sched: new clone flag CLONE_NEWCGROUP for cgroup
 namespace
Message-ID: <20141016160815.GB1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-3-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-3-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> CLONE_NEWCGROUP will be used to create new cgroup namespace.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  include/uapi/linux/sched.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..2f90d00 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -21,8 +21,7 @@
>  #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
>  #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
>  #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> -   and is now available for re-use. */
> +#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
>  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
>  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
