Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab3BZDss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:48:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50816 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3BZDsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:48:47 -0500
Date: Tue, 26 Feb 2013 03:48:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226034842.GD30285@srcf.ucam.org>
References: <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
 <20130226034250.GB30285@srcf.ucam.org>
 <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:45:24PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 7:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > The user Microsoft care about isn't running Linux
> 
> How f*cking hard is it for you to understand?
> 
> Stop arguing about what MS wants. We do not care. We care bout the
> *user*. You are continually missing the whole point of security, and
> then you make some idiotic arguments about what MS wants you to do.
> 
> It's irrelevant. The only thing that matters is what our *users* want
> us to do, and protecting *their* rights. As long as you seem to treat
> this as some kind of "let's please MS, not our users" issue, all your
> arguments are going to be crap.

Our users want to be able to boot Linux. If Microsoft blacklist a 
distribution's bootloader, that user isn't going to be able to boot 
Linux any more. How does that benefit our users? The user that wants to 
explicitly disable the security is free to do so ("mokutil 
--disable-validation" as root, follow the prompts, reboot), but if 
we only care about *our* users then Microsoft will gleefully blacklist 
us into complete irrelevance.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
