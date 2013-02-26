Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab3BZDjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:39:43 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:44810 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab3BZDjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:39:41 -0500
Date: Mon, 25 Feb 2013 19:40:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226034031.GA26591@kroah.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:28:39AM +0000, Matthew Garrett wrote:
> On Mon, Feb 25, 2013 at 10:25:08PM -0500, Theodore Ts'o wrote:
> > On Tue, Feb 26, 2013 at 03:13:38AM +0000, Matthew Garrett wrote:
> > > 
> > > Because Microsoft have indicated that they'd be taking a reactive 
> > > approach to blacklisting and because, so far, nobody has decided to 
> > > write the trivial proof of concept that demonstrates the problem.
> > 
> > Microsoft would take a severe hit both from a PR perspective, as well
> > as incurring significant legal risks if they did that in certain
> > jourisdictions --- in particular, I suspect in Europe, if Microsoft
> > were to break the ability of Linux distributions from booting, it
> > would be significantly frowned upon.
> 
> If a Linux vendor chose to knowingly breach the obligations they agreed 
> to, you don't think there'd be any PR hit?

What "vendor" is there in this case?  You released a signed shim, as did
the Linux Foundation, and lots of distros are now using it, and there
are absolutly no "orginization" behind a bunch of them.  Will your
signed shim be revoked because a random PoC was posted somewhere that
could be used with any kernel booted using it?

thanks,

greg k-h
