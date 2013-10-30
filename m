Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3J3VmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:42:13 -0400
Received: from fifo99.com ([67.223.236.141]:55865 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab3J3VmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:42:12 -0400
Date: Wed, 30 Oct 2013 14:42:02 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: misc: stcam: Renesas stcam device
Message-ID: <20131030214202.GA10071@fifo99.com>
References: <1383160668-8403-1-git-send-email-dwalker@fifo99.com>
 <20131030194206.GB8047@kroah.com>
 <20131030195015.GB8502@fifo99.com>
 <20131030212251.GA14155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030212251.GA14155@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:22:51PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 30, 2013 at 12:50:16PM -0700, Daniel Walker wrote:
> > On Wed, Oct 30, 2013 at 12:42:06PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Oct 30, 2013 at 12:17:48PM -0700, Daniel Walker wrote:
> > > > This is a driver for the ternary content addressable memory unit from Renesas. It
> > > > allows filtering on bits, and wildcards thru the chip.
> > > > 
> > > > Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> > > 
> > > What about the Cisco copyright?  Has that author signed off on this?
> > 
> > He's not aware of the release .. I can ask him to sign off, but I think
> > it's academic (he doesn't care).. I don't think he knows what a sign off
> > means.
> 
> You should at least ask, it's only nice to do so.

Ok, assuming I actually re-submit ..

> > > And why a separate driver, can't you do this all from userspace as a
> > > normal i2c driver?
> > 
> > I don't know , can I ? This is what Cisco is currently using ..
> 
> That doesn't mean anything, sorry.  We don't want to duplicate stuff
> that can already be done using i2c-dev and the like, right?

Would it matter if I said there was billion routers using this code?

The amount of work drops if I use the driver similar to it's current
form times 25.. I realize you don't give a rats ass about that, which is fine..

Most of the legacy drivers in i2c can be done in userspace it looks
like .. That means there's only super rare cases when you would take a
kernel i2c driver ?

> > > and most important, what is a "ternary content addressable memory unit"
> > > and what would you do with such a thing?
> > 
> > I asked the same question when I looked at the driver. It's in
> > wikipedia,
> > 
> > http://en.wikipedia.org/wiki/Content_addressable_memory#Ternary_CAMs
> > 
> > It used for filtering things by 0,1 or wildcard.. In Cisco case "things"
> > is packets.
> 
> That still doesn't explain what this driver is used for to me, sorry.
> Care to explain?

A packet goes into a switch, the TCAM is set to filter specific packets
to specific ports on the router (this is my understanding from wikipedia)
based on specific fields in the packets.. I'm not sure I can do much
better then that, but I'm sure someone with more network experience
could explain in more detail..

Daniel

