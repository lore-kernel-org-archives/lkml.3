Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3BZGEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:04:41 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49975 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab3BZGEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:04:40 -0500
Date: Tue, 26 Feb 2013 01:04:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226060428.GD12906@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
	keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:55:32PM +1000, Dave Airlie wrote:
> 
> So it would be nice if LF could undertake to go and talk to Microsoft,
> and get vague opinions turned into something real.

Uh, folks like James and Greg K-H have talked to folks at
Microsoft.... I haven't talked to the folks at Microsoft personally,
but my understanding is that did _not_ tell us we had to do what
Matthew claims other folks at Mircrosoft have claimed that we have to
do, "or else".

> Ted you might be at liberty to get a chromebook pixel from google, but
> that isn't going to help the other X% of users who have a PC they want
> to use Linux on, and maybe boot Windows to do their taxes.

The point is that users will have choices.  It wasn't the end of the
world when some laptop manufacturers shipped devices that required
crappy Nvidia drivers.  I just simply chose not to buy laptops that
were crippled with the Optimus chipset, and purchased laptops that
used Intel graphics instead.  That's the free market at work.

Yes, it's sad that some users got stuck buying hardware which screwed
them over and made it very hard or impossible to use bleeding edge
kernels.  It's too bad some people had to learn the hard way.  The
good news though is that people who did do their due diligence could
purchase open hardware, and not get screwed by peripherals that
required proprietary drivers, whether they be WiFi or Graphics
drivers.

Of course, there are still crappy laptops that require proprietary
drivers, or for which no Linux drivers exist at all.  There's a reason
why I buy Thinkpads and not Sony laptops.  Similarly, the good news is
that there are open x86 devices being sold right now, post Windows-8,
which don't require us to be beholden to Microsoft.  Yes, there will
be users who buy the locked down crap.  There are also users who buy
Sony laptops.  Sometimes, we can't help everyone, and somtimes, it's
better not to encourage users to use hardware that require propietary
drivers, but to rather incentize them to use open hardware instead.

Regards,

	     	       		      	 - Ted
