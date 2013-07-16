Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab3GPQl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:41:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37630 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454Ab3GPQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:41:53 -0400
X-Sasl-enc: 3pKidx8dVzeZk7fU2SZ8GO0R4f0me4PLP4F43f783vMW 1373992910
Date: Tue, 16 Jul 2013 09:36:15 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130716163615.GB17231@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373941801.31067.113.camel@deadeye.wl.decadent.org.uk>
 <20130716061324.GA19052@kroah.com>
 <alpine.LNX.2.00.1307161109480.29788@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307161109480.29788@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:11:24AM +0200, Jiri Kosina wrote:
> On Mon, 15 Jul 2013, Greg KH wrote:
> 
> > > Anything that's being reviewed on the stable list is public.  I know
> > > this is an old argument, but if you point out a fix you *know* has a
> > > security impact then you'll help general distribution maintainers and
> > > users a lot more than you help the black-hats who are quite capable of
> > > recognising such a fix (if they haven't already spotted and exploited
> > > the bug).
> > 
> > I'm sorry, but you know I will not do that, so asking about it isn't
> > going to change this behavior.
> 
> I just followed up in the other thread, where Ted was explaining why the 
> huge /dev/random rework was a -stable material.
> 
> Why specifically would it be wrong to be open about this being security 
> related, and providing the necessary data (i.e. at least reference to 
> http://factorable.net/) publically?
> 
> I fail to see what the point behind hiding this would be.

I'm not "hiding" anything, all I'm doing is using the exact same
changelog comments that are in Linus's tree, and nothing else.

greg k-h
