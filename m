Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab3BZENa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:13:30 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45676 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3BZEN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:13:28 -0500
Date: Mon, 25 Feb 2013 20:13:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226041324.GA7241@kroah.com>
References: <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226040456.GA30717@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:04:56AM +0000, Matthew Garrett wrote:
> On Mon, Feb 25, 2013 at 07:54:16PM -0800, Greg KH wrote:
> > On Tue, Feb 26, 2013 at 03:38:04AM +0000, Matthew Garrett wrote:
> > > On Mon, Feb 25, 2013 at 07:31:56PM -0800, Greg KH wrote:
> > > > So, once that proof is written, suddenly all of the working Linux
> > > > distros's keys will be revoked?  That will be fun to watch happen, and
> > > > odds are, it will not.  Imagine the PR fun that will cause :)
> > > 
> > > No. Why would they be?
> > 
> > Because they are using the "public" shim that you provided them, or the
> > Linux Foundation's shim.  Almost no distro, other than the "main" 3-4
> > will end up getting their own shim signed, the rest will just use the
> > one you so helpfully provided them :)
> 
> There's no reason for the LF or generic shim to be blacklisted, since 
> neither will load anything without manual intervention. But that also 
> means that anyone trying to boot them has to have some knowledge of 
> English, and that there's no way to netboot them. But sure, anyone 
> planning that approach has much less to worry about.

I don't see anything about "manual intervention" in the wording that you
provided from Microsoft absolving you from the "duty" you feel you owe
them.  I understand you are worried about "automated" exploits, but that
really is just a semantic overall, as we know it is easy to get people
to hit a key when booting just to get on with the process.

> > Yes you can.  There are all sorts of fun ways you can do this, I can
> > think of a few more at the moment as well.  So, where does it stop?
> > And why stop it at all?  Why not just forbid root users at all?
> 
> Because there's a distinction between ring 0 and ring 3?

Since when did you start trusting ring 0 code?  Bozos like me write this
stuff, surely it isn't secure :)

> > > Microsoft aren't dictating anything here. We're free not to use their 
> > > signatures. However, if we do use their signatures, we agree to play by 
> > > their rules. Nobody seems to have come up with a viable alternative, so 
> > > here we are.
> > 
> > Ok, I keep hearing people say, "why doesn't someone else create a
> > signing authority!" all the time.  And it comes down to one big thing,
> > money.
> 
> Right. We've failed at creating an alternative. That doesn't mean that 
> we get to skip the responsibilities associated with the choice we've 
> made.

Wait, who is "we" here?  The community?  The community over-all didn't
agree with anything with Microsoft, that is between the people getting a
signed key and Microsoft.  Again, you are trying to push your (prior)
company's agreement between them and Microsoft onto the community, and
now the community is pushing back, is that a surprise?

thanks,

greg k-h
