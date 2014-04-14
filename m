Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaDNQqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:46:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48263 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbaDNQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:46:35 -0400
Date: Mon, 14 Apr 2014 17:46:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chanho Min <chanho.min@lge.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64:kconfig: make default for CONFIG_COMPAT
Message-ID: <20140414164618.GC12916@arm.com>
References: <1397462883-12740-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397462883-12740-1-git-send-email-chanho.min@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:08:03AM +0100, Chanho Min wrote:
> 'make savedefconfig' doesn't generate defconfig properly due to
> missing COMPAT default. So Add default and set to yes.

I thought a missing `default' line in a Kconfig entry meant that the option
ended up defaulting to 'n'. What exactly is the problem you are seeing?

Will

> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  arch/arm64/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 4907b85..93b7531 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -294,6 +294,7 @@ source "fs/Kconfig.binfmt"
>  
>  config COMPAT
>  	bool "Kernel support for 32-bit EL0"
> +	default y
>  	depends on !ARM64_64K_PAGES
>  	select COMPAT_BINFMT_ELF
>  	select HAVE_UID16
> -- 
> 1.7.9.5
> 
> 
