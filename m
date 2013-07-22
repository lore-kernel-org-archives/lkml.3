Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3GVPLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:11:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36728 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755648Ab3GVPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:11:16 -0400
Date: Mon, 22 Jul 2013 11:11:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, Felipe Balbi <balbi@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] USB: host: Use usb_hcd_platform_shutdown() wherever
 possible
In-Reply-To: <1374494690-18169-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307221110390.1495-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Roger Quadros wrote:

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
>  drivers/usb/host/ehci-xilinx-of.c |   17 +----------------
>  drivers/usb/host/ohci-omap3.c     |   10 +---------
>  drivers/usb/host/ohci-ppc-of.c    |   11 +----------
>  8 files changed, 8 insertions(+), 82 deletions(-)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

