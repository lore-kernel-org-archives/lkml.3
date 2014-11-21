Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaKUXOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:14:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15568 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKUXOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:14:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/oGJywVGDojgJ39RFqbT3+
Date: Fri, 21 Nov 2014 15:14:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: linux-next: manual merge of the char-misc tree with the arm-soc
 tree
Message-ID: <20141121231411.GW7046@atomide.com>
References: <20141121172412.4caf89cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121172412.4caf89cc@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [141120 22:26]:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> arch/arm/mach-omap2/Kconfig between commit 9e1e632c4846 ("ARM: OMAP2+:
> Drop board file for ti8168evm") from the arm-soc tree and commit
> 184901a06a36 ("ARM: removing support for etb/etm in
> "arch/arm/kernel/"") from the char-misc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks right to me thanks.

Tony 
 
> diff --cc arch/arm/mach-omap2/Kconfig
> index 27ec8923ddf6,06020fe77e57..000000000000
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@@ -276,14 -282,16 +276,6 @@@ config MACH_SBC353
>   	default y
>   	select OMAP_PACKAGE_CUS
>   
> - config OMAP3_EMU
> - 	bool "OMAP3 debugging peripherals"
> - 	depends on ARCH_OMAP3
> - 	select ARM_AMBA
> - 	select OC_ETM
> - 	help
> - 	  Say Y here to enable debugging hardware of omap3
>  -config MACH_TI8168EVM
>  -	bool "TI8168 Evaluation Module"
>  -	depends on SOC_TI81XX
>  -	default y
>  -
>  -config MACH_TI8148EVM
>  -	bool "TI8148 Evaluation Module"
>  -	depends on SOC_TI81XX
>  -	default y
> --
>   config OMAP3_SDRC_AC_TIMING
>   	bool "Enable SDRC AC timing register changes"
>   	depends on ARCH_OMAP3


