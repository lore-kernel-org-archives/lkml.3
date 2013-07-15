Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3GOXP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:15:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45907 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3GOXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:15:56 -0400
Date: Mon, 15 Jul 2013 16:15:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
Message-ID: <20130715231555.GA24650@roeck-us.net>
References: <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <1373926109.17876.221.camel@gandalf.local.home>
 <20130715223615.GI15531@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715223615.GI15531@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:36:15PM -0700, Sarah Sharp wrote:
> On Mon, Jul 15, 2013 at 06:08:29PM -0400, Steven Rostedt wrote:
> > On Mon, 2013-07-15 at 14:50 -0700, Linus Torvalds wrote:
> > > On Mon, Jul 15, 2013 at 1:41 PM, Sarah Sharp
> > > <sarah.a.sharp@linux.intel.com> wrote:
> > > >
> > > > Oh, FFS, I just called out on private email for "playing the victim
> > > > card".  I will repeat: this is not just about me, or other minorities.
> > > > I should not have to ask for professional behavior on the mailing lists.
> > > > Professional behavior should be the default.
> > > 
> > > Bullshit.
> > > 
> > 
> > Can we please make this into a Kernel Summit discussion. I highly doubt
> > we would solve anything, but it certainly would be a fun segment to
> > watch :-)
> 
> I agree, KS is where this conversation should be taking place.
> Attendees for this conversation (so far) should be Greg KH, Linus,
> Darren Hart, Steve Rostedt, Willy Tarreau, and me.
> 
One thing you should keep in mind in your discussion is what can happen
if people get too polite with each other.

I have seen this happen at two large companies I worked for. Early on, flames
are acceptable and expected as response to someone publishing bad code which
breaks everything for everyone. Then, at some point, it is not acceptable
anymore to flame, and one is expected to be polite and friendly at all times.
"Your code breaks the build for every platform. Would you please kindly
consider fixing it ?"
Result is that code quality suffers, to the point where images don't even
build anymore.

I hope the Linux kernel never gets into that stage. To avoid that,
I am willing to be cursed at by Linus if I am the responsible party.

Guenter
