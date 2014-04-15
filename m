Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaDOTSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:18:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:54900 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaDOTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:17:59 -0400
Message-ID: <1397589429.21892.13.camel@vger.seibold.net>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        andreas.brief@rohde-schwarz.com
Date: Tue, 15 Apr 2014 21:17:09 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404151512030.1310-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404151512030.1310-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 15.04.2014, 15:14 -0400 schrieb Alan Stern:
> On Tue, 15 Apr 2014, Stefani Seibold wrote:
> 
> > > > usbcore: registered new interface driver USB-SATA-storage
> > > > USB SATA Mass Storage support registered.
> > > > usb 1-4: new high-speed USB device number 4 using ehci-pci
> > > > xxxx: ports detected
> > > 
> > > What driver is this?  I've never heard of USB-SATA-storage.
> > > 
> > 
> > This is a special embedded USB SATA driver written by me. It is mostly a
> > fork of the usb-storage driver but handle only one vendor and product ID
> > and does switch on a port bit. On the other side this vendor and product
> > ID is black listed in the regular usb-storage driver. 
> 
> Is it possible that your driver leaves the device in a strange state 
> where it won't initialize properly?
> 

I don't think so, because the driver was not used in this test due a
missing harddisk. But i will do a test tomorrow in the office.

- Stefani



