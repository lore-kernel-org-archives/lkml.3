Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3BRWi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:38:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52306 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757409Ab3BRWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:38:27 -0500
Date: Mon, 18 Feb 2013 17:38:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Otavio Salvador <otavio@ossystems.com.br>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
In-Reply-To: <CAP9ODKp3BNArKoWOVQ6D1-ky=fkir84SSp3V3WSdpnPwnTfdoA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1302181736430.6790-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Otavio Salvador wrote:

> >> I thought the ehci-pci module would be load for every ehci PCI; What
> >> do you think?
> >
> > The kernel can't guarantee anything about what driver modules are
> > loaded.  That's up to userspace.  In particular, the initramfs image
> > must be set up properly (if that is where these modules are loaded
> > from).
> 
> But why kernel cannot load it if we have a PCI subsystem? Or do you
> think my initrd did not put the module on the initramfs image?

That's exactly what I think.  See this message and the corresponding 
thread:

	http://marc.info/?l=linux-usb&m=136074995914335&w=2

Alan Stern

