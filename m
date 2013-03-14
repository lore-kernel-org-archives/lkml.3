Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab3CNPrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:47:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab3CNPrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:47:39 -0400
Date: Thu, 14 Mar 2013 16:47:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Hurley <peter@hurleysoftware.com>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <alpine.LNX.2.00.1303141634440.30118@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1303141644230.30118@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141111350.1983-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1303141634440.30118@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Jiri Kosina wrote:

> > Is occurrence of the "nobody cared" connected with any particular 
> > device?  Somebody reported a similar problem not long ago (although IIRC 
> > it was for OHCI rather than UHCI) which appeared to be related to 
> > activity on the built-in webcam.
> 
> Will check this. No external devices are plugged in, I think the only 
> internal one it has is bluetooth chip. I'll try turning it off.

That didn't help (I disabled it via hard rfkill and it vanished from 
lsusb), i.e. it happens even with only the hubs being there.

-- 
Jiri Kosina
SUSE Labs
