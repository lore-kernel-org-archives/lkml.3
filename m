Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3KGDMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:12:42 -0500
Received: from ozlabs.org ([203.10.76.45]:52839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3KGDMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:12:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
In-Reply-To: <1383685095.4387.45.camel@joe-AO722>
References: <1383685095.4387.45.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Nov 2013 12:32:50 +1030
Message-ID: <87zjph55px.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> This semicolon isn't necessary, remove it.
>
> Signed-off-by: Joe Perches <joe@perches.com>

This is a terrible description.  Really bad.

First, it just repeats the subject, with more words.

Second, it gives me no indication that you've done a grep to make sure
noone is abusing the macro, so I can't apply it without doing that check
myself.

Please try again.

Rusty.

> ---
>  include/linux/module.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 05f2447..d1ad477 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -454,7 +454,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>  
>  extern void __module_put_and_exit(struct module *mod, long code)
>  	__attribute__((noreturn));
> -#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
> +#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
>  
>  #ifdef CONFIG_MODULE_UNLOAD
>  unsigned long module_refcount(struct module *mod);
