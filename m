Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3G1S3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:29:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3G1S3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:29:53 -0400
Date: Sun, 28 Jul 2013 11:29:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
Message-ID: <20130728182952.GC16560@kroah.com>
References: <20130727.175541.1879192128080680197.davem@davemloft.net>
 <1374981271.2476.0.camel@deadeye.wl.decadent.org.uk>
 <20130728041616.GA32761@kroah.com>
 <20130727.213943.1973842777687951434.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130727.213943.1973842777687951434.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 09:39:43PM -0700, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Sat, 27 Jul 2013 21:16:16 -0700
> 
> > On Sun, Jul 28, 2013 at 04:14:31AM +0100, Ben Hutchings wrote:
> >> On Sat, 2013-07-27 at 17:55 -0700, David Miller wrote:
> >> > From: Ben Hutchings <ben@decadent.org.uk>
> >> > Date: Sat, 27 Jul 2013 16:58:28 +0100
> >> > 
> >> > > I'm not so sure this is suitable for stable.  It doesn't seem to be
> >> > > helpful to either userland or kernel code.
> >> > > 
> >> > > In the kernel, we were checking that ver == 1 and type == 1 thus this
> >> > > wasn't hurting us.
> >> > > 
> >> > > If userland does anything more with these fields then it's probably
> >> > > already working around the swapped fields.  It can work with both old
> >> > > and new headers by doing:
> >> > 
> >> > It's up to you, I would rather have the corrected version propagated
> >> > as soon as possible.  But that's just me.
> >> 
> >> Let's see what Greg thinks.
> > 
> > I'm guessing that Linus's tree is also "wrong" here, correct?  If so,
> > the fix that goes into that tree should also go here as well.
> > 
> > Or am I confused?
> 
> Linus's tree has had this change for a full release.  It went into
> 3.10

But isn't this a review of the 3.10-stable series?  So what is the
probme?

> It's correcting a mistake that has been there since the header
> file even existed.

Ok, then I think this should be made, fixes are good to have, right?

So, unless someone objects, I'll just keep this as-is.

thanks,

greg k-h
