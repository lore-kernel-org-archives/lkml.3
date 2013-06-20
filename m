Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3FTVmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:42:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3FTVmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:42:08 -0400
Date: Thu, 20 Jun 2013 14:42:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org, wokeswang@qnap.com
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
Message-ID: <20130620214207.GA12922@kroah.com>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
 <1371687272.30351.13.camel@heisenberg.scientia.net>
 <20130620025900.GA21820@kroah.com>
 <1371763706.5197.6.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371763706.5197.6.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:28:26PM +0200, Christoph Anton Mitterer wrote:
> Hey Greg.
> 
> On Wed, 2013-06-19 at 19:59 -0700, Greg KH wrote:
> > If you can dig the code out into a stand-alone form that I can make into
> > a patch for the drivers/staging/ tree, I'll be glad to take it.
> Well I don't think my kernel/hardware development skills are enough for
> that... especially as Guenter already said that the code shouldn't be
> part of hwmon/it87 ... but rather a separate gpio driver...

Fair enough.

> > Or, if
> > you get a contact at QNAP, I'll be glad to help out there as well
> Well I've asked them again,... no reply so far.
> The only direct contact I know (from the sources of their drivers) is
> Wokes Wang, which I've CCed. Perhaps he can help.

That would be great.  Also, do you have a pointer to the git tree for
the hardware again, I can't seem to find it.  I can dig through the tree
to see if I can make something "self-contained", if you are willing to
test it out.

thanks,

greg k-h
