Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3G1EPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 00:15:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3G1EPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 00:15:00 -0400
Date: Sat, 27 Jul 2013 21:16:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
Message-ID: <20130728041616.GA32761@kroah.com>
References: <20130726204721.849052763@linuxfoundation.org>
 <20130726204722.608161811@linuxfoundation.org>
 <1374940708.13555.37.camel@deadeye.wl.decadent.org.uk>
 <20130727.175541.1879192128080680197.davem@davemloft.net>
 <1374981271.2476.0.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374981271.2476.0.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 04:14:31AM +0100, Ben Hutchings wrote:
> On Sat, 2013-07-27 at 17:55 -0700, David Miller wrote:
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Date: Sat, 27 Jul 2013 16:58:28 +0100
> > 
> > > I'm not so sure this is suitable for stable.  It doesn't seem to be
> > > helpful to either userland or kernel code.
> > > 
> > > In the kernel, we were checking that ver == 1 and type == 1 thus this
> > > wasn't hurting us.
> > > 
> > > If userland does anything more with these fields then it's probably
> > > already working around the swapped fields.  It can work with both old
> > > and new headers by doing:
> > 
> > It's up to you, I would rather have the corrected version propagated
> > as soon as possible.  But that's just me.
> 
> Let's see what Greg thinks.

I'm guessing that Linus's tree is also "wrong" here, correct?  If so,
the fix that goes into that tree should also go here as well.

Or am I confused?

greg k-h
