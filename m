Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaLBOHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:07:06 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54298 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaLBOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:07:01 -0500
Date: Tue, 2 Dec 2014 22:06:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Freescale Vybrid SoC
Message-ID: <20141202140649.GJ2411@dragon>
References: <1417131235-3077-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417131235-3077-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:33:55AM +0100, Stefan Agner wrote:
> Add Freescale Vybrid family as a own entry, along with an entry for
> the so far orphan Vybrid device tree files. Also add myself as
> a designated reviewer.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
> Not sure if this is acceptable, but it would be nice when I get Vybrid
> related stuff automatically...
> 
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3c64271..6837f23 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -990,6 +990,16 @@ F:	arch/arm/mach-mxs/
>  F:	arch/arm/boot/dts/imx*
>  F:	arch/arm/configs/imx*_defconfig
>  
> +ARM/FREESCALE VYBRID ARM ARCHITECTURE
> +M:	Shawn Guo <shawn.guo@linaro.org>
> +M:	Sascha Hauer <kernel@pengutronix.de>
> +R:	Stefan Agner <stefan@agner.ch>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
> +F:	arch/arm/mach-imx/*vf610*
> +F:	arch/arm/boot/dts/vf*
> +
>  ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -- 
> 2.1.3
> 
