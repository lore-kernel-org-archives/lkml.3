Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaG2MiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:38:10 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60248 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaG2MiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:38:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, marek.belisko@gmail.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Date: Tue, 29 Jul 2014 14:38:24 +0200
Message-ID: <14357891.vooz1N5zDC@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53CF7978.4090709@ti.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com> <20140721151557.GH6852@saruman.home> <53CF7978.4090709@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2014 14:29:36 Kishon Vijay Abraham I wrote:
> On Monday 21 July 2014 08:45 PM, Felipe Balbi wrote:
> > On Mon, Jul 21, 2014 at 05:04:57PM +0200, Laurent Pinchart wrote:
> >> Hi Felipe,
> >> 
> >> What happened to these two patches ?
> > 
> > looks like I lost them.
> > 
> >> On Monday 16 December 2013 17:48:29 Felipe Balbi wrote:
> >>> On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> >>>> * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> >>>>> On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I 
wrote:
> >>>>>> After the platform devices are created using PLATFORM_DEVID_AUTO, the
> >>>>>> device names given in usb_bind_phy (in board file) does not match
> >>>>>> with the actual device name causing the USB PHY library not to return
> >>>>>> the PHY reference when the MUSB controller request for the PHY in the
> >>>>>> non-dt boot case.
> >>>>>> So removed creating platform devices using PLATFORM_DEVID_AUTO in
> >>>>>> omap2430.c.
> >>>>>> 
> >>>>>> Did enumeration testing in omap3 beagle.
> >>>>>> 
> >>>>>> Changes from v2:
> >>>>>> * Fixed the commit log
> >>>>>> 
> >>>>>> Changes from v1:
> >>>>>> * refreshed to the latested mainline kernel
> >>>>>> * added musb_put_id from omap2430 remove.
> >>>>> 
> >>>>> Tony, how do you want to handle this ? You want me to provide you a
> >>>>> branch which we both merge ?
> >>>> 
> >>>> Yes that would be great thanks. For the mach-omap2 touching parts:
> >>>> 
> >>>> Acked-by: Tony Lindgren <tony@atomide.com>
> >>> 
> >>> Here it is, let me know if you prefer a signed tag:
> >>> 
> >>> The following changes since commit 
6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> >>>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> >>> 
> >>> are available in the git repository at:
> >>>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> >>> 
> >>> usb-phy-binding-omap3
> >>> 
> >>> for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d52d18:
> >>>   arm: omap: remove *.auto* from device names given in usb_bind_phy
> >>> 
> >>> (2013-12-16 17:44:43 -0600)
> >>> 
> >>> ----------------------------------------------------------------
> >>> 
> >>> Kishon Vijay Abraham I (2):
> >>>       usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
> >>>       arm: omap: remove *.auto* from device names given in usb_bind_phy
> > 
> > Kishon, are these still valid ?
> 
> Looks like board-2430sdp.c got removed. Apart from that the reset of the
> patch series is still applicable for non-dt boot.

Felipe, do you plan to apply the patch without the baord-2430sdp.c change, or 
would you like Kishon to rebase and resubmit it ?

-- 
Regards,

Laurent Pinchart

