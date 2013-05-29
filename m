Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967505Ab3E3Fek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:34:40 -0400
Received: from ozlabs.org ([203.10.76.45]:46234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967420Ab3E3Fec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:34:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>
Cc: lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix comment typo "CONFIG_PAE"
In-Reply-To: <1369812619.23034.4.camel@x61.thuisdomein>
References: <1369812619.23034.4.camel@x61.thuisdomein>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 30 May 2013 09:29:22 +0930
Message-ID: <87bo7tmj6t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Please note that I don't really understand this comment, but
> the fix is correct anyhow.

Applied.  And it just means that we can use the kernel (host) macros to
operate on the guest page tables, since they are both PAE or both
non-PAE.

Thanks!
Rusty.

>  drivers/lguest/page_tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
> index 5b9ac32..a35d8d1 100644
> --- a/drivers/lguest/page_tables.c
> +++ b/drivers/lguest/page_tables.c
> @@ -70,7 +70,7 @@
>  /*H:320
>   * The page table code is curly enough to need helper functions to keep it
>   * clear and clean.  The kernel itself provides many of them; one advantage
> - * of insisting that the Guest and Host use the same CONFIG_PAE setting.
> + * of insisting that the Guest and Host use the same CONFIG_X86_PAE setting.
>   *
>   * There are two functions which return pointers to the shadow (aka "real")
>   * page tables.
> -- 
> 1.7.11.7
