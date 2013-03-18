Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3CRCuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:50:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61590 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3CRCuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:50:09 -0400
Date: Sun, 17 Mar 2013 19:51:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>, Dongsheng Song <dongsheng.song@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.8.3
Message-ID: <20130318025123.GC3028@kroah.com>
References: <20130314184702.GA17860@kroah.com>
 <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
 <20130317193321.GA15102@arwen.pp.htv.fi>
 <20130317195709.GC4977@n2100.arm.linux.org.uk>
 <87ip4p4wjh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ip4p4wjh.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 09:10:42PM +0100, Bjørn Mork wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > Sigh.
> >
> > At times, I really don't know why I bother wasting my time commenting on
> > patches if they just go and agree with them, and promptly ignore them.
> > I pointed out what this should be:
> >
> > http://marc.info/?l=linux-kernel&m=135972750522902&w=2
> >
> > And it was agreed:
> >
> > http://marc.info/?l=linux-kernel&m=135993546317541&w=2
> >
> > But for some reason the wrong patch got merged:
> >
> > http://marc.info/?l=git-commits-head&m=136147889001219&w=2
> >
> > Maybe because it was "simpler" ?  Don't know.  But... well, we now know
> > what the outcome of it was.  Let's try a different technique.  I'm going
> > to say nothing of any real help and hopefully it will get fixed properly.
> > Maybe that'll work.
> 
> To be fair, looking at the commitdate of that commit it was already in
> Greg's tree when you commented on it.  So the discussion you had would
> have to be about a followup-fix to this, and not about that particular
> patch.

Yes, I thought someone was going to send me a follow-on patch to fix
this, that is what Minchan said, after I had committed it.

Anyway, it's a staging driver, if it doesn't build, that's not a big
deal.

greg k-h
