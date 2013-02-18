Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3BRWJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:09:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38036 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757108Ab3BRWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:09:10 -0500
Date: Mon, 18 Feb 2013 17:09:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Otavio Salvador <otavio@ossystems.com.br>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
In-Reply-To: <CAP9ODKrFqj_LTvvx-D5ERxjGcpp4FP6WsvrvkoFBJM-gaPihvw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1302181707320.6790-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2013, Otavio Salvador wrote:

> On Sun, Feb 10, 2013 at 12:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sun, 10 Feb 2013, Otavio Salvador wrote:
> >> I do have EHCI and PCI enabled so it should be working. Any clue about
> >> why it breaks it?
> >
> > Perhaps your system is not loading the new ehci-pci kernel module.
> 
> Yes; it should be the cause as building it built-in makes it work.
> However it is a regression from my point of view.
> 
> Those are the controllers I have in my system:
> 
> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
> 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
> 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
> 
> I thought the ehci-pci module would be load for every ehci PCI; What
> do you think?

The kernel can't guarantee anything about what driver modules are 
loaded.  That's up to userspace.  In particular, the initramfs image 
must be set up properly (if that is where these modules are loaded 
from).

Alan Stern

