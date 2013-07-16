Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3GPMqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:46:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14907 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3GPMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:46:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dIxjQhBGTYyhhC1nwkeAM
Date: Tue, 16 Jul 2013 05:46:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm: omap: remove using usb_bind_phy for
 binding musb and phy
Message-ID: <20130716124618.GA7656@atomide.com>
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
 <1373282057-20181-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373282057-20181-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130708 04:21]:
> Now that MUSB for OMAP started using devm_usb_get_phy_by_name
> which does not require PHY library to already have the binding
> information, removed usb_bind_phy calls that binds the MUSB controller
> with the PHY from the board files.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>
> ---
>  arch/arm/mach-omap2/board-2430sdp.c          |    1 -
>  arch/arm/mach-omap2/board-3430sdp.c          |    1 -
>  arch/arm/mach-omap2/board-cm-t35.c           |    1 -
>  arch/arm/mach-omap2/board-devkit8000.c       |    1 -
>  arch/arm/mach-omap2/board-igep0020.c         |    1 -
>  arch/arm/mach-omap2/board-ldp.c              |    1 -
>  arch/arm/mach-omap2/board-omap3beagle.c      |    1 -
>  arch/arm/mach-omap2/board-omap3evm.c         |    1 -
>  arch/arm/mach-omap2/board-omap3logic.c       |    1 -
>  arch/arm/mach-omap2/board-omap3pandora.c     |    1 -
>  arch/arm/mach-omap2/board-omap3stalker.c     |    1 -
>  arch/arm/mach-omap2/board-omap3touchbook.c   |    1 -
>  arch/arm/mach-omap2/board-overo.c            |    1 -
>  arch/arm/mach-omap2/board-rm680.c            |    1 -
>  arch/arm/mach-omap2/board-rx51.c             |    1 -
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    1 -
>  16 files changed, 16 deletions(-)

It's best that I queue this as a follow up patch after
the other patches are merged. Otherwise we'll be introducing
pointless merge conflicts with board-*.c files changing
and disappearing as we move to DT based booting.

Regards,

Tony
