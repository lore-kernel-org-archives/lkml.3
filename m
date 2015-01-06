Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbbAFP3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:29:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbbAFP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:29:29 -0500
Date: Tue, 6 Jan 2015 09:29:21 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Christoph Jaeger <cj@linux.com>
Cc: sjenning@redhat.com, jkosina@suse.cz, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] livepatch: kconfig: use bool instead of
 boolean
Message-ID: <20150106152921.GB16854@treble.redhat.com>
References: <1420515249-4848-1-git-send-email-cj@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420515249-4848-1-git-send-email-cj@linux.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 10:34:09PM -0500, Christoph Jaeger wrote:
> Keyword 'boolean' for type definition attributes is considered deprecated and
> should not be used anymore. No functional changes.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Reference: http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

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

-- 
Josh
