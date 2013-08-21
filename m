Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3HUUQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:16:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:16:02 -0400
Date: Wed, 21 Aug 2013 13:16:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
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
Message-ID: <20130821201600.GA10321@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <20130821053836.GF16424@1wt.eu>
 <20130821133713.GA16493@home.goodmis.org>
 <20130821172327.GB2398@pompeji.miese-zwerge.org>
 <20130821135816.41127e6f@gandalf.local.home>
 <20130821200702.GA10762@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821200702.GA10762@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:07:03PM +0200, Borislav Petkov wrote:
> On Wed, Aug 21, 2013 at 01:58:16PM -0400, Steven Rostedt wrote:
> > The point I'm making, we should be more reluctant in pulling patches
> > into stable as quick as we are. A patch ideally should simmer in
> > linux-next for a bit, then go into mainline.
> 
> Oh, and it is really debatable if the sheer volume of -stable patches is
> actually warranted - several people already raised the question whether
> we should be more conservative with the stable tag. But you're probably
> going to have this as one of the topics at KS...

And I pushed back on that.  Which specific stable patch should _not_
have been included?

I am going to be pickier (and already have, as some maintainers have
found out), with what I accept, but so far, the number of patches I've
rejected can be counted on one hand, a very small percentage of the
overall number of stable patches.

thanks,

greg k-h
