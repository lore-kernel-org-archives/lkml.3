Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934659Ab3BNPDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:03:45 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:55764 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621Ab3BNPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:03:43 -0500
Date: Thu, 14 Feb 2013 07:03:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 02/20] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
Message-ID: <20130214150351.GD2033@kroah.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
 <1358937492-8129-3-git-send-email-rogerq@ti.com>
 <511CB9E9.5050804@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511CB9E9.5050804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 12:18:17PM +0200, Roger Quadros wrote:
> Hi Greg,
> 
> On 01/23/2013 12:37 PM, Roger Quadros wrote:
> > Let's have a single platform data structure for the OMAP's High-Speed
> > USB host subsystem instead of having 3 separate ones i.e. one for
> > board data, one for USB Host (UHH) module and one for USB-TLL module.
> > 
> > This makes the code much simpler and avoids creating multiple copies of
> > platform data.
> > 
> > CC: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > For the ehci-omap.c part:
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Could you please ACK the drivers/usb/host/ehci-omap.c part
> so that this can go through the MFD tree. Thanks.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

