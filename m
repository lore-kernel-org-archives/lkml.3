Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031074Ab3HIU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:28:10 -0400
Received: from 1wt.eu ([62.212.114.60]:35248 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031006Ab3HIU2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:28:08 -0400
Date: Fri, 9 Aug 2013 22:28:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809202802.GG4079@1wt.eu>
References: <20130809015010.208118575@linuxfoundation.org> <20130809192030.GD4079@1wt.eu> <20130809193329.GA5792@kroah.com> <20130809200056.GF4079@1wt.eu> <20130809200838.GA7335@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809200838.GA7335@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:08:38PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 10:00:56PM +0200, Willy Tarreau wrote:
> > Just get a Beaglebone Black, it's $45 and Cortex A8 (armv7). Well buy
> > two, since you'll use the first one for hacking GPIOs to everything :-)
> > 
> >    http://beagleboard.org/Products/BeagleBone%20Black
> 
> I have a pre-production version of this, but I don't think that
> everything it needs to work is currently upstream :(

Ah I never checked indeed. I only got one so it stayed at step 1 (GPIO).

> > If you want to do cool stuff, the AX3 is by far the best thing I've seen
> > to date, really, but it's too expensive for a non-profit developer in my
> > opinion :
> > 
> >    https://openblocks.plathome.com/form/obs_verification/input.html
> 
> Does it work with a "clean" upstream kernel.org release?

Yes, I just booted mine with exactly the mbox patches applied on
top of plain 3.10.5. There's a SATA SSD in it so that you don't even
need to care about the MTD stuff etc... I'm used to boot mine over
the network with a rootfs in the initrd, so everything runs in RAM
because it's more convenient for me, it boots in about 8 seconds.

It started to work since 3.8 and is fine with 3.10+. 3.11 brings
PCIe and some stuff you won't necessarily need for kernel dev.

You won't have the NEON extensions on it (but I doubt you'd need it).

Willy

