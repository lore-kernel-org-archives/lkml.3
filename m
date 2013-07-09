Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3GIOQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:16:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36294 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752553Ab3GIOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:16:38 -0400
Date: Tue, 9 Jul 2013 10:16:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: host: Use usb_hcd_platform_shutdown() wherever
 possible
In-Reply-To: <1373367529-13713-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307091015310.1077-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Roger Quadros wrote:

> Most HCD drivers are doing the same thing in their ".shutdown" callback
> so it makes sense to use the generic usb_hcd_platform_shutdown()
> handler there.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-grlib.c     |   11 +----------
>  drivers/usb/host/ehci-mxc.c       |   10 +---------
>  drivers/usb/host/ehci-omap.c      |   10 +---------
>  drivers/usb/host/ehci-ppc-of.c    |   11 +----------
>  drivers/usb/host/ehci-s5p.c       |   10 +---------
>  drivers/usb/host/ehci-tegra.c     |   10 +---------
>  drivers/usb/host/ehci-xilinx-of.c |   17 +----------------
>  drivers/usb/host/ohci-omap3.c     |   10 +---------
>  8 files changed, 8 insertions(+), 81 deletions(-)

This all looks fine.  But unless my kernel tree is out of date, you 
missed ohci-ppc-of.c.

Alan Stern

