Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3COSe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:34:57 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45061 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3COSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:34:55 -0400
Date: Fri, 15 Mar 2013 11:34:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>,
        David Haerdeman <david@hardeman.nu>, sarah.a.sharp@linux.intel.com,
        balbi@ti.com
Subject: Re: [PATCH][v3] xhci: correctly enable interrupts
Message-ID: <20130315183451.GA17907@kroah.com>
References: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
 <1742014.AbCVskUi8i@skinner.arch.suse.de>
 <2543963.ytZ3mOsUVV@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2543963.ytZ3mOsUVV@skinner.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 11:45:28AM +0100, Thomas Renninger wrote:
> On Monday, March 04, 2013 05:14:43 PM Thomas Renninger wrote:
> > From: Hannes Reinecke <hare@suse.de>
> > 
> > xhci has its own interrupt enabling routine, which will try to
> > use MSI-X/MSI if present. So the usb core shouldn't try to enable
> > legacy interrupts; on some machines the xhci legacy IRQ setting
> > is invalid.
> > 
> > v3: Be careful to not break XHCI_BROKEN_MSI workaround (by trenn)
> > 
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Oliver Neukum <oneukum@suse.de>
> > Cc: Thomas Renninger <trenn@suse.de>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Frederik Himpe <fhimpe@vub.ac.be>
> > Cc: David Haerdeman <david@hardeman.nu>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Reviewed-by: Thomas Renninger <trenn@suse.de>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Argh, I should have added:
> CC: stable@kernel.org

You mean "stable@vger.kernel.org" :)

I'll go do it...

thanks,

greg k-h
