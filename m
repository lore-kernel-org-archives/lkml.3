Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3BZVlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab3BZVlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:41:07 -0500
Date: Tue, 26 Feb 2013 16:40:53 -0500
From: Peter Jones <pjones@redhat.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226214052.GJ32160@fenchurch.internal.datastacks.com>
References: <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
 <20130226034250.GB30285@srcf.ucam.org>
 <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
 <20130226034842.GD30285@srcf.ucam.org>
 <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
 <87bob6pxtl.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87bob6pxtl.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:30:46PM +0100, Florian Weimer wrote:
> * Linus Torvalds:
> 
> > So here's what I would suggest, and it is based on REAL SECURITY and
> > on PUTTING THE USER FIRST instead of your continual "let's please
> > microsoft by doing idiotic crap" approach.
> 
> I think the real question is this one: Is there *any* device out there
> which comes with Microsoft Secure Boot enabled, but doesn't have a
> copy of Windows 8 on it?
> 
> I guess there isn't.  So Secure Boot support is only required for
> supporting dual-booting Windows 8, while still retaining the automated
> recovery capabilities (which might well remove the Linux installation
> on the same box).
> 
> Without dual-booting, there is currently no reason whatsoever to
> enable UEFI Secure Boot (or the Microsoft variant).

It prevents a form of malware which exists in the wild.  I think that's
enough reason to want *something*, though SB isn't necessarily what
we'd have dreamed of.  Nevertheless, SB is what we've got, and as such
is why we've been working on how to use it meaningfully.

This all seems pretty orthogonal to the question at hand, of course.

-- 
        Peter
