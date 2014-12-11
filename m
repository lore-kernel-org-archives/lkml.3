Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaLKBqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:46:21 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:51012 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbaLKBqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:46:19 -0500
Date: Thu, 11 Dec 2014 10:46:11 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: trivial - fix the help doc of CONFIG_CC_OPTIMIZE_FOR_SIZE
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1407217387-23479-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1407217387-23479-1-git-send-email-yamada.m@jp.panasonic.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141211104609.A487.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Does this seem OK?



On Tue,  5 Aug 2014 14:43:07 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> Other than GCC, we have another choice, Clang for building the kernel
> these days.  It seems better to say "compiler" rather than "gcc".
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
>  init/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 41066e4..7bc7c05 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1259,8 +1259,8 @@ endif
>  config CC_OPTIMIZE_FOR_SIZE
>  	bool "Optimize for size"
>  	help
> -	  Enabling this option will pass "-Os" instead of "-O2" to gcc
> -	  resulting in a smaller kernel.
> +	  Enabling this option will pass "-Os" instead of "-O2" to
> +	  your compiler resulting in a smaller kernel.
>  
>  	  If unsure, say N.
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


