Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab3BZDtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:49:45 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49945 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3BZDto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:49:44 -0500
Date: Mon, 25 Feb 2013 22:49:35 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226034935.GB12906@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
	keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226032839.GA30164@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:28:39AM +0000, Matthew Garrett wrote:
> You're happy advising Linux vendors that they don't need to worry about 
> module signing because it's "not obvious" that Microsoft would actually 
> enforce the security model they've spent significant money developing 
> and advertising?

My advice was to Linus and those who are willing to listen to me, not
to Red Hat.  Red Hat has not generally been receptive to my advice in
the past; not that they have any obligation to listen to me, of
course.  After all, I'm not on Red Hat's payroll.  :-)

Speaking more generally, though, (a) revoking the Linux's key is not
zero-cost to Microsoft, (b) it's also not an instant death sentence to
Linux distributions.  Users can always either disable secure boot
mode, or they can install another signing key.  Yes, that is not the
best user experience, but it's something which is doable.

The other thing to consider is that it's not clear in the long run how
much of a lock Microsoft and Windows 8 will have hardware
manufacturers.  There's already been people discussing how to install
Linux on the Chromebook Pixel.  Other traditional PC manufacturers,
including HP and Lenovo, have started creating non-Windows-8 x86
systems using ChromeOS, which can easily have a stock Linux distro
installed on it, and they come at a variety of different price points.
(Heck, the recent ChromeOS boxes, such as Pixel, come with an open
source BIOS which you can reflash.)

Finally note that secure boot is not an issue on server platforms,
which is where most of the traditional Linux vendors have made their
money.  And those who are making money with pre-installed Linux
systems (i.e., like Ubuntu, or Google with ChromeOS) for consumers are
generally doing so in cooperation with hardware OEM partners, where
there's no reason to kowtow to Microsoft's policies.  So there really
isn't a good reason for Linux vendors to cower in fear of Microsoft.

Much of Microsoft power comes from people letting them have power over
them.  You don't have to do it.  Sometimes it's better to let them
carry through on their threat, and while it will be inconvenient, it
is highly likely they will also take damage from their taking action.
Consider what happened the last time the Republicans carried through
on their threat to shut down the US Federal Government.  Sometimes
it's better to let the blackmailers carry through on their threat, and
then steps from there.  Cowering in fear and paying Danegled rarely
gets rid of the Dane.

Regards,

						- Ted

