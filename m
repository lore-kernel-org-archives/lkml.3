Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3J0QFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:05:37 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422Ab3J0QFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:05:36 -0400
Message-ID: <526D39AF.4010508@nod.at>
Date: Sun, 27 Oct 2013 17:05:03 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: remove used STDIO_CONSOLE Kconfig param
References: <1382857570-3412-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382857570-3412-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.10.2013 08:06, schrieb Michael Opdenacker:
> This removes the STDIO_CONSOLE Kconfig parameter which
> is defined but no longer used anywhere in the makefiles and source code.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Looks good.
Queued for 3.13.

Thanks,
//richard

> ---
>  arch/um/Kconfig.char | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
> index b9d7c42..f10738d 100644
> --- a/arch/um/Kconfig.char
> +++ b/arch/um/Kconfig.char
> @@ -6,10 +6,6 @@ config STDERR_CONSOLE
>  	help
>  	  console driver which dumps all printk messages to stderr.
>  
> -config STDIO_CONSOLE
> -	bool
> -	default y
> -
>  config SSL
>  	bool "Virtual serial line"
>  	help
> 

