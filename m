Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3BZE7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:59:22 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58268 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3BZE7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:59:21 -0500
Date: Tue, 26 Feb 2013 04:59:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226045917.GB31181@srcf.ucam.org>
References: <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <20130226042338.GA30944@srcf.ucam.org>
 <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:43:59PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 8:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > If the user has explicitly enrolled a hash then they're stepping outside
> > the trust model.
> 
> This is the kind of totally bogus crap that no sane person should ever
> spout. Stop it.
> 
> If the user has explicitly enrolled a hash, then that should be the
> *primary* trust model, dammit. That should be very much what you
> should care about first and foremost, and that should be your goal in
> life. That's when the user says "I'm in control of my own machine, and
> I want to trust *this*".

The user has stepped outside the original trust model ("I trust anything 
signed by Microsoft and only things signed by Microsoft") and into a new 
one ("I trust things that I say I trust"). That's a great thing for a 
user to do, but it also means that once the user's done it we don't need 
to give a fuck about what Microsoft think. They're irrelevant once the 
user's made that choice.

> It's not about "stepping outside of the trust model". Quite the
> reverse. It's about actually being *part* of the trust model, and
> taking control of your own machine. It's the *good* scenario. It's
> what you should encourage users to do.

I wholeheartedly agree.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
