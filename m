Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbbAFIPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:15:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbbAFIPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:15:22 -0500
Date: Tue, 6 Jan 2015 09:15:36 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Christoph Jaeger <cj@linux.com>
Cc: jpoimboe@redhat.com, sjenning@redhat.com, jkosina@suse.cz, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] livepatch: kconfig: use bool instead of
 boolean
Message-ID: <20150106081536.GA18193@pathway.suse.cz>
References: <1420515249-4848-1-git-send-email-cj@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420515249-4848-1-git-send-email-cj@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-05 22:34:09, Christoph Jaeger wrote:
> Keyword 'boolean' for type definition attributes is considered deprecated and
> should not be used anymore. No functional changes.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Reference: http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks for the patch.

Best Regards,
Petr

> ---
>  kernel/livepatch/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
> index 96da00f..66797aa 100644
> --- a/kernel/livepatch/Kconfig
> +++ b/kernel/livepatch/Kconfig
> @@ -1,10 +1,10 @@
>  config ARCH_HAVE_LIVE_PATCHING
> -	boolean
> +	bool
>  	help
>  	  Arch supports kernel live patching
>  
>  config LIVE_PATCHING
> -	boolean "Kernel Live Patching"
> +	bool "Kernel Live Patching"
>  	depends on DYNAMIC_FTRACE_WITH_REGS
>  	depends on MODULES
>  	depends on SYSFS
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
