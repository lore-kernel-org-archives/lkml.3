Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3COFEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:04:11 -0400
Received: from ozlabs.org ([203.10.76.45]:40763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3COFEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:04:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] export.h: clarify comment in relation to avoiding includes
In-Reply-To: <1363267573-2146-1-git-send-email-paul.gortmaker@windriver.com>
References: <1363267573-2146-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Mar 2013 15:24:15 +1030
Message-ID: <87hakdtg94.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> The existing comment indicated what was desired, but it didn't
> necessarily convey the reasoning behind it in an effective way.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/export.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/export.h b/include/linux/export.h
> index 696c0f4..d14cf26 100644
> --- a/include/linux/export.h
> +++ b/include/linux/export.h
> @@ -5,8 +5,9 @@
>   * to reduce the amount of pointless cruft we feed to gcc when only
>   * exporting a simple symbol or two.
>   *
> - * If you feel the need to add #include <linux/foo.h> to this file
> - * then you are doing something wrong and should go away silently.
> + * More specifically, it was all the #include <linux/foo.h> lines in
> + * module.h that we wanted to avoid, so please avoid adding any such
> + * similar include lines here, if at all possible.
>   */
>  
>  /* Some toolchains use a `_' prefix for all user symbols. */
> -- 
> 1.8.1.2

I prefer that :)

Thanks,
Rusty.
