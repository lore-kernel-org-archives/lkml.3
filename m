Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3HIRqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:46:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56207 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758476Ab3HIRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:46:41 -0400
Date: Fri, 9 Aug 2013 13:46:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Richter <richter@rus.uni-stuttgart.de>
cc: linux@brodo.de, <linux-kernel@vger.kernel.org>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <52048567.6020704@rus.uni-stuttgart.de>
Message-ID: <Pine.LNX.4.44L0.1308091345060.1405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Thomas Richter wrote:

> Hi Alan, hi Dominik,
> 
> maybe you want me to help out a bit - I'm having trouble getting a 
> Delock PCMCIA to USB-2 adapter to work under linux, with strange 
> behavior in some situations. The trouble is that while I can *read* via 
> fast (usb 2.0) transfers from the port, an ehci-triggered write just 
> locks up (it does not Oops, though) and I'm pretty much stuck narrowing 
> down the problem.

The best way to start will be to enable CONFIG_USB_DEBUG in your kernel 
and post the dmesg log.  Also post a usbmon trace showing what happens 
when you try to write something.

Alan Stern

