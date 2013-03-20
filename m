Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3CTUOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:14:51 -0400
Received: from mout.gmx.net ([212.227.17.22]:59938 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3CTUOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:14:47 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/tnhoR2IvtGoTon1KKfewXv+ho7TBVaiKhoH+UAN
	Y9vImuGWLgZNGB
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI controllers
References: <Pine.LNX.4.44L0.1303191700040.1302-100000@iolanthe.rowland.org>
	<871ubb83pd.fsf@turtle.gmx.de> <20130320200852.GA5899@kroah.com>
Date: Wed, 20 Mar 2013 21:14:38 +0100
In-Reply-To: <20130320200852.GA5899@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 20 Mar 2013 13:08:52 -0700")
Message-ID: <87y5dhbzgx.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-20 21:08 +0100, Greg Kroah-Hartman wrote:

> On Tue, Mar 19, 2013 at 10:44:30PM +0100, Sven Joachim wrote:
>> On 2013-03-19 22:00 +0100, Alan Stern wrote:
>> 
>> > On Tue, 19 Mar 2013, Sven Joachim wrote:
>> >
>> >> On 2013-03-19 21:10 +0100, Alan Stern wrote:
>> >> 
>> >> > On Tue, 19 Mar 2013, Sven Joachim wrote:
>> >> >
>> >> >> > In what way is resume broken?
>> >> >> 
>> >> >> The kernel comes back, but the screen is black.  Manually switching VT's
>> >> >> is possible, and if I type something I can see it on the screen, but
>> >> >> there is no response and the cursor does not blink.  It looks as if the
>> >> >> VT is not switched backed on resume, and userspace tasks are not
>> >> >> restarted.  Sysrq combinations apparently work, but produce no output.
>> >> >
>> >> > Are there any other problems?  For example, even before you do a 
>> >> > suspend, if you type Alt-SysRq-W do you see any processes listed?
>> >> 
>> >> No.
>> >> 
>> >> > There was another report on the linux-usb mailing list today of this
>> >> > same patch causing the khubd task to hang.  I'm thinking that you might
>> >> > be facing a similar problem.
>> >> 
>> >> Maybe, but before the suspend everything seems to be normal.
>> >
>> > Just out of curiosity, does the patch posted here:
>> >
>> > 	http://marc.info/?l=linux-usb&m=136361874807411&w=2
>> >
>> > make any difference?
>> 
>> It fixes the problem for me, thanks. :-)
>
> Ok, I'll postpone this patch for the next stable release, in time for
> the fix to be put in at the same time.

I think patch 13/75 ("USB: EHCI: dont check DMA values in QH overlays")
should also be postponed then, at least Alan said so in
<Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>.

Cheers,
       Sven
