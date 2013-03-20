Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3CTUHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:07:45 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:61914 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3CTUHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:07:43 -0400
Date: Wed, 20 Mar 2013 13:08:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI
 controllers
Message-ID: <20130320200852.GA5899@kroah.com>
References: <Pine.LNX.4.44L0.1303191700040.1302-100000@iolanthe.rowland.org>
 <871ubb83pd.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ubb83pd.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:44:30PM +0100, Sven Joachim wrote:
> On 2013-03-19 22:00 +0100, Alan Stern wrote:
> 
> > On Tue, 19 Mar 2013, Sven Joachim wrote:
> >
> >> On 2013-03-19 21:10 +0100, Alan Stern wrote:
> >> 
> >> > On Tue, 19 Mar 2013, Sven Joachim wrote:
> >> >
> >> >> > In what way is resume broken?
> >> >> 
> >> >> The kernel comes back, but the screen is black.  Manually switching VT's
> >> >> is possible, and if I type something I can see it on the screen, but
> >> >> there is no response and the cursor does not blink.  It looks as if the
> >> >> VT is not switched backed on resume, and userspace tasks are not
> >> >> restarted.  Sysrq combinations apparently work, but produce no output.
> >> >
> >> > Are there any other problems?  For example, even before you do a 
> >> > suspend, if you type Alt-SysRq-W do you see any processes listed?
> >> 
> >> No.
> >> 
> >> > There was another report on the linux-usb mailing list today of this
> >> > same patch causing the khubd task to hang.  I'm thinking that you might
> >> > be facing a similar problem.
> >> 
> >> Maybe, but before the suspend everything seems to be normal.
> >
> > Just out of curiosity, does the patch posted here:
> >
> > 	http://marc.info/?l=linux-usb&m=136361874807411&w=2
> >
> > make any difference?
> 
> It fixes the problem for me, thanks. :-)

Ok, I'll postpone this patch for the next stable release, in time for
the fix to be put in at the same time.

thanks,

greg k-h
