Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaIPQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:09:26 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59060 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753743AbaIPQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:09:25 -0400
Date: Tue, 16 Sep 2014 17:09:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] arm: Remove redundant config value DEBUG_UART_NETX
Message-ID: <20140916160917.GK12361@n2100.arm.linux.org.uk>
References: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:09:46PM +0100, Daniel Thompson wrote:
> Commit 880fa9b6fd73 ("ARM: 8144/1: netx: Migrate DEBUG_LL macros to
> shared directory") spuriously introduces an unused config variable,
> DEBUG_UART_NETX. Let's remove it.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

I think arm-soc are handing these changes now...

> ---
>  arch/arm/Kconfig.debug | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 537dd04..b6ec25a 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -450,7 +450,6 @@ choice
>  	config DEBUG_NETX_UART
>  		bool "Kernel low-level debugging messages via NetX UART"
>  		depends on ARCH_NETX
> -		select DEBUG_UART_NETX
>  		help
>  		  Say Y here if you want kernel low-level debugging support
>  		  on Hilscher NetX based platforms.
> -- 
> 1.9.3
> 

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
