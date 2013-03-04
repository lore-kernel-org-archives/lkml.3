Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab3CDRgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:36:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45020 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758430Ab3CDRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:36:12 -0500
Date: Mon, 4 Mar 2013 12:36:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Thomas Renninger <trenn@suse.de>, Hannes Reinecke <hare@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>,
        David Haerdeman <david@hardeman.nu>
Subject: Re: [PATCH][v3] xhci: correctly enable interrupts
In-Reply-To: <5134E331.30303@cogentembedded.com>
Message-ID: <Pine.LNX.4.44L0.1303041234460.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Sergei Shtylyov wrote:

> > @@ -371,6 +371,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
> >   		return -EINVAL;
> >   	}
> >
> > + legacy_irq:
> >    
> 
>     Labels shouldn't be indented by a space (unless the existing coding 
> style has them indented already, of course).
> Although that might be a rule dropped by checkpatch.pl already -- it 
> doesn't complain.

Indeed, there's a definite advantage to putting a space before a label:  
The diff program doesn't get confused into thinking the label is the
start of a new function.

Alan Stern

