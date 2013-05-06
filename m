Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3EFHyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:54:40 -0400
Received: from ozlabs.org ([203.10.76.45]:47343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab3EFHyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:54:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Baluta <dbaluta@ixiacom.com>, lguest@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Daniel Baluta <dbaluta@ixiacom.com>
Subject: Re: [PATCH v2] lguest: rename i386_head.S
In-Reply-To: <1367578917-21083-1-git-send-email-dbaluta@ixiacom.com>
References: <1367578917-21083-1-git-send-email-dbaluta@ixiacom.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 06 May 2013 16:01:24 +0930
Message-ID: <87obcopqkj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta <dbaluta@ixiacom.com> writes:

> Since commit 9a163ed8e0 (i386: move kernel) kernel/i386_head.S
> was renamed to kernel/head_32.S. We do the same for lguest/i386_head.S.
>
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>

Better.  Applied.

Thanks,
Rusty.

> ---
> Changes since v1:
> 	* use head_32.o in Makefile
>
>  arch/x86/lguest/Makefile                   |    2 +-
>  arch/x86/lguest/{i386_head.S => head_32.S} |    0
>  2 files changed, 1 insertions(+), 1 deletions(-)
>  rename arch/x86/lguest/{i386_head.S => head_32.S} (100%)
>
> diff --git a/arch/x86/lguest/Makefile b/arch/x86/lguest/Makefile
> index 94e0e54..8f38d57 100644
> --- a/arch/x86/lguest/Makefile
> +++ b/arch/x86/lguest/Makefile
> @@ -1,2 +1,2 @@
> -obj-y		:= i386_head.o boot.o
> +obj-y		:= head_32.o boot.o
>  CFLAGS_boot.o	:= $(call cc-option, -fno-stack-protector)
> diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/head_32.S
> similarity index 100%
> rename from arch/x86/lguest/i386_head.S
> rename to arch/x86/lguest/head_32.S
> -- 
> 1.7.5.4
