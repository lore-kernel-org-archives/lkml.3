Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab3BZPi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:38:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546Ab3BZPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:38:55 -0500
Date: Tue, 26 Feb 2013 10:38:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226153846.GA16094@redhat.com>
References: <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
 <20130226034250.GB30285@srcf.ucam.org>
 <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
 <20130226034842.GD30285@srcf.ucam.org>
 <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
 <20130226045747.GA31181@srcf.ucam.org>
 <20130226153045.GA10535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226153045.GA10535@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:30:45AM -0500, Vivek Goyal wrote:
> On Tue, Feb 26, 2013 at 04:57:47AM +0000, Matthew Garrett wrote:
> 
> [..]
> > >  - encourage things like per-host random keys - with the stupid UEFI
> > > checks disabled entirely if required. They are almost certainly going
> > > to be *more* secure than depending on some crazy root of trust based
> > > on a big company, with key signing authorities that trust anybody with
> > > a credit card. Try to teach people about things like that instead.
> > > Encourage people to do their own (random) keys, and adding those to
> > > their UEFI setups (or not: the whole UEFI thing is more about control
> > > than security), and strive to do things like one-time signing with the
> > > private key thrown out entirely. IOW try to encourage *that* kind of
> > > "we made sure to ask the user very explicitly with big warnings and
> > > create his own key for that particular module" security. Real
> > > security, not "we control the user" security.
> > 
> > Yes, ideally people will engage in self-signing and distributions will 
> > have mechanisms for dealing with that.
> 
> So even if a user installs its own keys in UEFI to boot self signed
> shim, kernel and modules, I am assuming that we will still need to
> make sure kexec does not load and run an unsigned kernel? (Otherwise
> there is no point in installing user keys in UEFI and there is an
> easy way to bypass it). 

As I am kind of lost in the long mail thread, so I will ask. If a user
installs its own keys in UEFI database and boots self signed linux
kernel, will we still make sure that no unsigned code can be run at
ring 0 (without explicitly asking user on console).

Thanks
Vivek
