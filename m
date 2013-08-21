Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3HUNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:37:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3HUNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:37:17 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wom5GMh1gUkA:10 a=roXeUe4e85gA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JzSCUfRX3cwA:10 a=VwQbUJbxAAAA:8 a=AIXmSJp-6wMKP3QmP28A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 09:37:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821133713.GA16493@home.goodmis.org>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <20130821053836.GF16424@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821053836.GF16424@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First I want to say that I 100% support the idea of waiting at least one
-rc. Maybe even two.

On Wed, Aug 21, 2013 at 07:38:36AM +0200, Willy Tarreau wrote:
> > 	Cc: stable <stable@vger.kernel.org> # after -rc5 is out
> > or
> > 	Cc: stable <stable@vger.kernel.org> # wait a -rc cycle
> > or
> > 	Cc: stable <stable@vger.kernel.org> # wait a few weeks to bake
> 
> That's where I think that the default one (with no indication) should
> be the higher delay. If the author has no clue about the emergency of
> his patch, who else can guess for him ?
> 
> It's too optimistic to consider that some code authors will be
> realist about the impacts of their code. We all create bugs and
> regressions everywhere because we're sure about what we do, until
> someone says "hey dude you broke this". So if we expect authors to
> say "look, I managed to get this merged into mainline but I'm still
> not sure about the risks", I suspect only a small fraction of the
> patches will be tagged this way. But I may be wrong, after all it
> already works well with -net.

Really, most fixes are for regressions. If it isn't something that can
let non root crash the kernel, or have access that they shouldn't have,
then let it simmer in the kernel for a while. I don't see any reason to
rush out a regression fix if it just causes a device not to work
anymore. The user can go back to the old kernel for a week or two and
wait. Even with two weeks (or even a month) of waiting, we are still much
faster than Apple or Microsoft in getting regression fixes out.

If people are not rushing to update their kernel to stable every time a
new stable is released then why are we rushing to get them out?

Maybe people are rushing, but I don't update my main machines every
stable release because I can't always afford the down time it causes me
to do so.

-- Steve

