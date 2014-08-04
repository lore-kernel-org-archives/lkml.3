Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaHDOVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:21:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55162 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751650AbaHDOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:21:53 -0400
Date: Mon, 4 Aug 2014 10:21:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
cc: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Kernel Debugging Support
In-Reply-To: <53DF707F.8090102@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1408041007330.1169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Austin S Hemmelgarn wrote:

> On 2014-08-02 09:48, Alan Stern wrote:
> > On Sat, 2 Aug 2014, Nick Krause wrote:
> > 
> >> Hey Sharp,
> >> After reading around seems people want support for usb debugging in
> >> kgdb or other usb based solutions.
> >> If you and the other developers are able to help me out a bit as I am
> >> new I can definitively write this
> >> area of kgdb support.
> > 
> > Doesn't kgdb already support USB for debugging?
> > 
> > Alan Stern
> 
> AFAICT, on x86 it only supports using either a console capable serial
> port (so you could do that over USB if you have USB serial console
> support built-in, but most people I know don't compile that in, and in
> fact that is the only reason that i compile USB serial support in
> instead of making it a module), and an AT compatible keyboard with any
> console option.

What about with a USB debugging device (CONFIG_EARLY_PRINTK_DBGP)?  
That's how debugging over USB is _supposed_ to be done.

>  It would be really nice to have USB keyboard support in
> there so that you don't have to reboot with special options and extra
> hardware plugged in to get to the debugger, although doing something
> that supports more than just the HID boot protocol will probably be tricky.

Is there some reason why kgdb doesn't simply use the kernel's input 
layer?  If there is, that same reason probably prevents it from using 
USB.

Alan Stern

