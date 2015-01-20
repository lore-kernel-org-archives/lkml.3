Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbbATMtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:49:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbbATMtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:49:31 -0500
Date: Tue, 20 Jan 2015 06:49:26 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: sjenning@redhat.com, jkosina@suse.cz, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmladek@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH] livepatch: change ARCH_HAVE_LIVE_PATCHING to
 HAVE_LIVE_PATCHING
Message-ID: <20150120124926.GB15916@treble.redhat.com>
References: <1421754575-30071-1-git-send-email-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421754575-30071-1-git-send-email-mbenes@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 12:49:35PM +0100, Miroslav Benes wrote:
> Change ARCH_HAVE_LIVE_PATCHING to HAVE_LIVE_PATCHING in Kconfigs. HAVE_
> bools are prevalent there and we should go with the flow.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

> ---
>  arch/x86/Kconfig         | 2 +-
>  kernel/livepatch/Kconfig | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 460b31b..29b0952 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -17,7 +17,7 @@ config X86_64
>  	depends on 64BIT
>  	select X86_DEV_DMA_OPS
>  	select ARCH_USE_CMPXCHG_LOCKREF
> -	select ARCH_HAVE_LIVE_PATCHING
> +	select HAVE_LIVE_PATCHING
>  
>  ### Arch settings
>  config X86
> diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
> index 66797aa..347ee22 100644
> --- a/kernel/livepatch/Kconfig
> +++ b/kernel/livepatch/Kconfig
> @@ -1,4 +1,4 @@
> -config ARCH_HAVE_LIVE_PATCHING
> +config HAVE_LIVE_PATCHING
>  	bool
>  	help
>  	  Arch supports kernel live patching
> @@ -9,7 +9,7 @@ config LIVE_PATCHING
>  	depends on MODULES
>  	depends on SYSFS
>  	depends on KALLSYMS_ALL
> -	depends on ARCH_HAVE_LIVE_PATCHING
> +	depends on HAVE_LIVE_PATCHING
>  	help
>  	  Say Y here if you want to support kernel live patching.
>  	  This option has no runtime impact until a kernel "patch"
> -- 
> 2.1.2
> 

-- 
Josh
