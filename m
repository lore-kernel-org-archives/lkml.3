Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3GPJL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:11:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3GPJL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:11:26 -0400
Date: Tue, 16 Jul 2013 11:11:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
In-Reply-To: <20130716061324.GA19052@kroah.com>
Message-ID: <alpine.LNX.2.00.1307161109480.29788@pobox.suse.cz>
References: <1373916476.2748.69.camel@dabdike> <20130715214422.GA2478@kroah.com> <1373941801.31067.113.camel@deadeye.wl.decadent.org.uk> <20130716061324.GA19052@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Greg KH wrote:

> > Anything that's being reviewed on the stable list is public.  I know
> > this is an old argument, but if you point out a fix you *know* has a
> > security impact then you'll help general distribution maintainers and
> > users a lot more than you help the black-hats who are quite capable of
> > recognising such a fix (if they haven't already spotted and exploited
> > the bug).
> 
> I'm sorry, but you know I will not do that, so asking about it isn't
> going to change this behavior.

I just followed up in the other thread, where Ted was explaining why the 
huge /dev/random rework was a -stable material.

Why specifically would it be wrong to be open about this being security 
related, and providing the necessary data (i.e. at least reference to 
http://factorable.net/) publically?

I fail to see what the point behind hiding this would be.

Thanks,

-- 
Jiri Kosina
SUSE Labs
