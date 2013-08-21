Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3HUVAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:00:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44121 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab3HUVAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:00:10 -0400
Date: Wed, 21 Aug 2013 23:00:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Jochen Striepe <jochen@tolot.escape.de>, Willy Tarreau <w@1wt.eu>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821210008.GA15410@nazgul.tnic>
References: <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <20130821053836.GF16424@1wt.eu>
 <20130821133713.GA16493@home.goodmis.org>
 <20130821172327.GB2398@pompeji.miese-zwerge.org>
 <20130821135816.41127e6f@gandalf.local.home>
 <20130821200702.GA10762@nazgul.tnic>
 <20130821201600.GA10321@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130821201600.GA10321@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:16:00PM -0700, Greg KH wrote:
> And I pushed back on that. Which specific stable patch should _not_
> have been included?

Well, here's one for example:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=f0a56c480196a98479760862468cc95879df3de0
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717473#54

I decided not to tag it for stable, even though Ben wanted it, just
because it is the first bug report for this and it was caused by a
pretty unusual hardware configuration. It simply wasn't important enough
to need to add it to stable, IMO.

So basically the rules at the beginning of
Documentation/stable_kernel_rules.txt didn't really apply and that's why
I held off on it.

And I'm pretty sure I've seen similar minor issues like that simply
"automatically" tagged for stable - I just don't have more concrete
examples right now.

> I am going to be pickier (and already have, as some maintainers have
> found out), with what I accept, but so far, the number of patches I've
> rejected can be counted on one hand, a very small percentage of the
> overall number of stable patches.

Ok, fair enough. I mean, in the end of the day, it is less work for you
and for distro people. And more importantly, less unnecessary work. :-)

Thanks.
