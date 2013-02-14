Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3BNQsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:48:14 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40675 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751249Ab3BNQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:48:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qOUrzC5HAmPbav6EM9IVI
Date: Thu, 14 Feb 2013 08:48:08 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arm-soc: OMAP USB Host cleanup for 3.9
Message-ID: <20130214164808.GZ7144@atomide.com>
References: <511CD215.8080005@ti.com>
 <511CD2CE.2020802@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511CD2CE.2020802@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130214 04:08]:
> Hi Tony,
> 
> This is the ARM-soc part of the OMAP USB Host cleanup series for 3.9.
> It is based on 3.8-rc6 + usbhost17-common that I sent earlier.
> 
> Please pull. Thanks.

Thanks for reworking this series! I'll pull this.

Regards,

Tony
 
> The following changes since commit 7f07863ec60f7d3dbeec5aff881ea074db3925ed:
> 
>   ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3) (2013-02-13 13:22:34 +0200)
> 
> are available in the git repository at:
>   git://github.com/rogerq/linux.git usbhost17-for-arm-soc
> 
> Roger Quadros (1):
>       ARM: OMAP: Consolidate OMAP USB-HS platform data (part 3/3)
> 
>  arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
>  arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
>  arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
>  arch/arm/mach-omap2/board-igep0020.c       |    4 +-
>  arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
>  arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
>  arch/arm/mach-omap2/board-overo.c          |    2 +-
>  arch/arm/mach-omap2/board-zoom.c           |    2 +-
>  arch/arm/mach-omap2/usb-host.c             |   29 ++++-----------------------
>  arch/arm/mach-omap2/usb.h                  |   20 +------------------
>  18 files changed, 23 insertions(+), 60 deletions(-)
> 
> --
> cheers,
> -roger
