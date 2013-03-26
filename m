Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040Ab3CZI2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:28:00 -0400
Received: from londo.lunn.ch ([80.238.139.98]:33651 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565Ab3CZI14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:27:56 -0400
Date: Tue, 26 Mar 2013 09:27:43 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Soeren Moch <smoch@web.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Stefan Peter <s.peter@mpl.ch>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: kirkwood: add MACH_GURUPLUG_DT to defconfig
Message-ID: <20130326082743.GN5627@lunn.ch>
References: <1364043502-17716-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364043502-17716-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:58:22PM +0100, Sebastian Hesselbarth wrote:
> This patch just adds the missing MACH_GURUPLUG_DT to kirkwood_defconfig.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Soeren Moch <smoch@web.de>

Acked-by: Andrew Lunn <andrew@lunn.ch>

> ---
> Cc: Soeren Moch <smoch@web.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Stefan Peter <s.peter@mpl.ch>
> Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/configs/kirkwood_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
> index 13482ea..5e40f96 100644
> --- a/arch/arm/configs/kirkwood_defconfig
> +++ b/arch/arm/configs/kirkwood_defconfig
> @@ -24,6 +24,7 @@ CONFIG_MACH_IB62X0_DT=y
>  CONFIG_MACH_TS219_DT=y
>  CONFIG_MACH_DOCKSTAR_DT=y
>  CONFIG_MACH_GOFLEXNET_DT=y
> +CONFIG_MACH_GURUPLUG_DT=y
>  CONFIG_MACH_LSXL_DT=y
>  CONFIG_MACH_IOMEGA_IX2_200_DT=y
>  CONFIG_MACH_KM_KIRKWOOD_DT=y
> -- 
> 1.7.10.4
> 
