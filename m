Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3HURbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:31:45 -0400
Received: from oker.escape.de ([194.120.234.254]:52010 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3HURbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:31:43 -0400
Date: Wed, 21 Aug 2013 19:23:27 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821172327.GB2398@pompeji.miese-zwerge.org>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <20130821053836.GF16424@1wt.eu>
 <20130821133713.GA16493@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821133713.GA16493@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

just speaking as a user, not a developer.

On Wed, Aug 21, 2013 at 09:37:13AM -0400, Steven Rostedt wrote:
> First I want to say that I 100% support the idea of waiting at least one
> -rc. Maybe even two.

I think so, too. But ...

> Really, most fixes are for regressions.
[...]
> If people are not rushing to update their kernel to stable every time a
> new stable is released then why are we rushing to get them out?

... people are very different. Many just update here and then, but
there are those who do update on most stable releases. Those are the
ones you get feedback and testing from, and I think you should encourage
them to update as soon as a new -stable kernel is released. Getting
regression fixes fast sounds like a good encouragement especially for
people interested in the -stable series. Keeping the number of
regressions low is the whole point of -stable, right?

> Maybe people are rushing, but I don't update my main machines every
> stable release because I can't always afford the down time it causes me
> to do so.

On my server/router and on my desktop machine it's the same, those are
for daily work. But I have a netbook for playing around. :)


Have a nice day,
Jochen.
