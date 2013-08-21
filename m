Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3HUSPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:15:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3HUSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:15:35 -0400
Date: Wed, 21 Aug 2013 11:15:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821181533.GA25438@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <CA+5PVA4Bf7mbB9qFWPfcX-xQDeKPoBKSjW_hF-td9sUUkFRDJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4Bf7mbB9qFWPfcX-xQDeKPoBKSjW_hF-td9sUUkFRDJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:03:12PM -0400, Josh Boyer wrote:
> Suspend/Resume is broken on a variety of Thinkpad T400 and T500
> machines in 3.10.  This was true with 3.10.0 afaik.  Current thinking
> is that it's related to the Intel mei/mei_me driver(s).  Blacklisting
> those seems to fix things for a number of users.  There are patches in
> 3.11-rcX, but the "fix" highlighted doesn't fix it.

I have heard of mei issues recently, but no real "this is a problem"
type thing.  There are some patches queued up for 3.12 in that area, if
they are needed earlier, that would be great for me, as a subsystem
maintainer, to know.

> I'm aware I'm reporting issues that you either already knew about or
> were already fixed.  The problem we have is that we roll out a new
> stable release and then we get bug reports for 2 weeks because not
> everyone updates as frequently as stable releases, etc.  So something
> that may seem to impact a small number of users at the time winds up
> actually impacting lots of users once it rolls out in a distro.  As
> far as I know, Fedora is possibly the only distro actually pushing
> stable release kernels out on a normal basis.  I'd love to be wrong on
> that point.

The openSUSE Tumbleweed disto also pushes out these stable kernels.  But
there's only an "estimated" 8-10 thousand users of that openSUSE
"flavor", while smaller than what Fedora has, it's better than nothing.

> In the future, if we can get the information from the end user in
> time, I'll be happy to forward issues that aren't already reported
> onwards.  Or if you still want to hear about it, I can chime in on the
> existing threads with bugzilla numbers.  I'm also willing to do a
> monthly "patches we're carrying not in stable" report if people find
> that helpful.

I would love that report, one of the things I keep asking for is for
people to send the patches that distros have that are not in stable to
me, as those obviously are things that are needed for a valid reason
that everyone should be able to benifit from.

> I'll likely be doing that within Fedora already and I'm happy to send
> it to stable@, even if those patches aren't exactly stable-rules
> matching.

If they aren't "allowed" by the current rules, I'd be interested to know
why, unless it's the "add a new feature" type thing, which makes sense
why I couldn't take them.

> We did that when kernel.org went down and it helped then, just not
> sure how much it would help now or if people care.

I care :)

thanks,

greg k-h
