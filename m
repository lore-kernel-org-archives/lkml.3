Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3HZOrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:47:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751694Ab3HZOrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:47:52 -0400
Date: Mon, 26 Aug 2013 10:47:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Guenter Roeck <linux@roeck-us.net>, Meelis Roos <mroos@linux.ee>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: Re: Commit 9a11899 (USB: OHCI: add missing PCI PM callbacks to
 ohci-pci.c) breaks several builds
In-Reply-To: <20130826042653.GA2778@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1308261036530.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Aug 2013, Greg Kroah-Hartman wrote:

> On Sun, Aug 25, 2013 at 09:02:15PM -0700, Guenter Roeck wrote:
> > On 08/25/2013 08:30 PM, Guenter Roeck wrote:
> > > Broken builds:
> > >      mips:ath79_defconfig
> > >      parisc:defconfig
> > >      sparc32:defconfig
> > >      sparc64:defconfig
> > >      tile:defconfig
> > >
> > Add:
> > 	powerpc:ppc64e_defconfig
> > 	powerpc:cell_defconfig
> > 	powerps:maple_defconfig
> > 
> > That makes it 8 out of 82 builds, or roughly 10% of all builds.
> > 
> > My qemu test build for powerpc (which has its own config file)  fails as well :(.
> 
> Ugh, I got no reports of this from linux-next or the 0-day build system,
> odd.
> 
> Alan, can you send a follow-on patch to fix this?

I seem to have a blind spot for this sort of thing.  Oh well, follow-on
patch coming up...

Alan Stern

