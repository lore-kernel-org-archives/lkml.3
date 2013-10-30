Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3J3VWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:22:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3J3VWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:22:52 -0400
Date: Wed, 30 Oct 2013 14:22:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: misc: stcam: Renesas stcam device
Message-ID: <20131030212251.GA14155@kroah.com>
References: <1383160668-8403-1-git-send-email-dwalker@fifo99.com>
 <20131030194206.GB8047@kroah.com>
 <20131030195015.GB8502@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030195015.GB8502@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:50:16PM -0700, Daniel Walker wrote:
> On Wed, Oct 30, 2013 at 12:42:06PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 30, 2013 at 12:17:48PM -0700, Daniel Walker wrote:
> > > This is a driver for the ternary content addressable memory unit from Renesas. It
> > > allows filtering on bits, and wildcards thru the chip.
> > > 
> > > Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> > 
> > What about the Cisco copyright?  Has that author signed off on this?
> 
> He's not aware of the release .. I can ask him to sign off, but I think
> it's academic (he doesn't care).. I don't think he knows what a sign off
> means.

You should at least ask, it's only nice to do so.

> > And why a separate driver, can't you do this all from userspace as a
> > normal i2c driver?
> 
> I don't know , can I ? This is what Cisco is currently using ..

That doesn't mean anything, sorry.  We don't want to duplicate stuff
that can already be done using i2c-dev and the like, right?

> > and most important, what is a "ternary content addressable memory unit"
> > and what would you do with such a thing?
> 
> I asked the same question when I looked at the driver. It's in
> wikipedia,
> 
> http://en.wikipedia.org/wiki/Content_addressable_memory#Ternary_CAMs
> 
> It used for filtering things by 0,1 or wildcard.. In Cisco case "things"
> is packets.

That still doesn't explain what this driver is used for to me, sorry.
Care to explain?

thanks,

greg k-h
