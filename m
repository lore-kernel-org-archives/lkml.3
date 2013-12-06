Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3LFMOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:14:41 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59564 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3LFMOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:14:40 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.57.210]
In-Reply-To: <1386331571-30903-3-git-send-email-kishon@ti.com>
References: <1386331571-30903-1-git-send-email-kishon@ti.com>
	<1386331571-30903-3-git-send-email-kishon@ti.com>
Date: Fri, 6 Dec 2013 13:14:38 +0100
Message-ID: <CABxcv=n67gNq6ayx+t_mfZ0++UBKkXpH9avXvRKFEH4VUrwy0g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm: omap: remove *.auto* from device names given
 in usb_bind_phy
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Fri, Dec 6, 2013 at 1:06 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while creating
> MUSB core device. So in usb_bind_phy (binds the controller with the PHY), the
> device name of the controller had *.auto* in it. Since with using
> PLATFORM_DEVID_AUTO, there is no way to know the exact device name in advance,
> the data given in usb_bind_phy became obsolete and usb_get_phy was failing.
> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Corresponding
> change is done in board file here.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
>  arch/arm/mach-omap2/board-ldp.c            |    2 +-
>  arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
>  arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
>  arch/arm/mach-omap2/board-overo.c          |    2 +-
>  arch/arm/mach-omap2/board-rx51.c           |    2 +-
>  12 files changed, 12 insertions(+), 12 deletions(-)
>

You can drop this patch since boards files are being removed for v3.14

Thanks a lot and best regards,
Javier
