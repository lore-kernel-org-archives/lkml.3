Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3AKQdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:33:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3AKQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:33:20 -0500
Date: Fri, 11 Jan 2013 16:32:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, sameo@linux.intel.com,
        tony@atomide.com, gregkh@linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, kishon@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if
	required
Message-ID: <20130111163255.GF23505@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.44L0.1301111019340.1730-100000@iolanthe.rowland.org> <50F037C9.40306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F037C9.40306@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 06:03:21PM +0200, Roger Quadros wrote:
> diff --git a/include/linux/platform_data/usb-omap.h
> b/include/linux/platform_data/usb-omap.h
> index d63eb7d..927b8a1 100644
> --- a/include/linux/platform_data/usb-omap.h
> +++ b/include/linux/platform_data/usb-omap.h
> @@ -38,6 +38,12 @@ enum usbhs_omap_port_mode {
>  	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
>  };
> 
> +struct usbhs_phy_config {
> +	char *name;		/* binds to device driver */

You may wish to consider making this const.
