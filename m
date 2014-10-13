Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaJMNPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:15:06 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:40596
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaJMNPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:15:02 -0400
Date: Mon, 13 Oct 2014 15:15:00 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        sgrubb@redhat.com, aviro@redhat.com, pmoore@redhat.com,
        arozansk@redhat.com, ebiederm@xmission.com, serge@hallyn.com
Subject: Re: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
Message-ID: <20141013131500.GH24703@mail.hallyn.com>
References: <cover.1412543112.git.rgb@redhat.com>
 <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> ---

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

>  include/uapi/linux/sched.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..5aceba2 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -28,6 +28,12 @@
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
>  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
> +#define CLONE_NEW_MASK	( CLONE_NEWNS \
> +			| CLONE_NEWUTS \
> +			| CLONE_NEWIPC \
> +			| CLONE_NEWUSER \
> +			| CLONE_NEWPID \
> +			| CLONE_NEWNET)	/* mask of all namespace type flags */
>  #define CLONE_IO		0x80000000	/* Clone io context */
>  
>  /*
> -- 
> 1.7.1
