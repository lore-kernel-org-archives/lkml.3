Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3GBPIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:08:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52509 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752968Ab3GBPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:08:09 -0400
Date: Tue, 2 Jul 2013 11:08:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
Subject: Re: [PATCH v2 4/4] usb: ohci-ep93xx: tidy up driver (*probe) and
 (*remove)
In-Reply-To: <201307011553.02910.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.44L0.1307021107450.1086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, H Hartley Sweeten wrote:

> Merge the usb_hcd_ep93xx_probe() into ohci_hcd_ep93xx_drv_probe() and
> the usb_hcd_ep93xx_remove() into ohci_hcd_ep93xx_drv_remove(). As Alan
> Stern pointed out, there is no reason for them to be separate.
> 
> Also, as Alan Stern suggested, eliminate the ep93xx_start_hc() and
> ep93xx_stop_hc() routines and simply call clk_enable() and clk_disable()
> directly. The extra level of redirection does not add any clarity.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

