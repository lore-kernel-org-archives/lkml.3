Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3BZD2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:28:49 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58111 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3BZD2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:28:46 -0500
Date: Tue, 26 Feb 2013 03:28:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226032839.GA30164@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226032508.GA12906@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 10:25:08PM -0500, Theodore Ts'o wrote:
> On Tue, Feb 26, 2013 at 03:13:38AM +0000, Matthew Garrett wrote:
> > 
> > Because Microsoft have indicated that they'd be taking a reactive 
> > approach to blacklisting and because, so far, nobody has decided to 
> > write the trivial proof of concept that demonstrates the problem.
> 
> Microsoft would take a severe hit both from a PR perspective, as well
> as incurring significant legal risks if they did that in certain
> jourisdictions --- in particular, I suspect in Europe, if Microsoft
> were to break the ability of Linux distributions from booting, it
> would be significantly frowned upon.

If a Linux vendor chose to knowingly breach the obligations they agreed 
to, you don't think there'd be any PR hit?

> So Microsoft may have privately threatened this to certain Red Hat
> attendees (threats are cheap, but it's not obvious that they would
> necessarily follow through on this threat.

You're happy advising Linux vendors that they don't need to worry about 
module signing because it's "not obvious" that Microsoft would actually 
enforce the security model they've spent significant money developing 
and advertising?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
