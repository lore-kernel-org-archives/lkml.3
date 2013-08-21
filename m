Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3HUALQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:11:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37906 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3HUALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:11:15 -0400
Date: Tue, 20 Aug 2013 17:11:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821001111.GB5441@roeck-us.net>
References: <20130820224032.GA20491@kroah.com>
 <20130820231117.GA24702@roeck-us.net>
 <20130820231743.GA992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820231743.GA992@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:17:43PM -0700, Greg KH wrote:
> On Tue, Aug 20, 2013 at 04:11:17PM -0700, Guenter Roeck wrote:
> > It would be even better if you could find the time to push -rc releases
> > into the stable repository before you accept patches into a stable branch.
> 
> What do you mean by this?
>
> The git tree?  I could do that, but when I have to drop a patch, it
> would cause a mess if I had to always go forwards.
> 
That is not what I mean. I referred to the master branch of the stable
repository, which you normally update to the most recent -rc when you
publish a new -stable release.

> I could do branches for -rc releases, that end up as the
> "end-of-the-line", and I create the next .y release on top of the
> previous one, not the -rc release.
> 
I would not ask for creating any new branches. The existing ones are good
enough.

> That's kind of what I do "internally" when I create the -rc releases in
> the first place, but I just delete those throw-away trees, and never
> push them publicly anywhere.
> 
> Does it really help anyone to do this, except for some automated
> testing?  Doesn't the -rc patch work good enough for that?
> 
> > I am now running my test suite on stable/master, so that would give it
> > some time to catch new problems before they make their way into a stable
> > branch.
> 
> I don't understand what you mean here.
> 
The master branch of linux-stable.git on kernel.org currently points to
v3.11-rc5. All I asked for is to update it to the latest -rc prior to
accepting patches from this -rc into a stable release.

I am running my test suite on linux-stable:master to have a reference
and comparison against the various -stable branches. As soon as you update
the master branch of linux-stable.git (eg after you push v3.11-rc6 into it),
the test suite will automatically run on it.

Obviously I could track linux-kernel.git itself instead, but there is much more
activity on it and I am really only interested in the most recent tagged version.

Hope that describes it better.

Guenter
