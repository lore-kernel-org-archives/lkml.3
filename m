Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3BYPmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:42:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45578 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab3BYPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:42:41 -0500
Date: Mon, 25 Feb 2013 15:42:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130225154236.GC13605@srcf.ucam.org>
References: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <567.1361470653@warthog.procyon.org.uk>
 <20130221182511.GA22156@srcf.ucam.org>
 <878v6c79av.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v6c79av.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 03:33:12PM +0100, Florian Weimer wrote:
> * Matthew Garrett:
> 
> > I don't think that's a problem. Just put the original binary hash in the 
> > certificate before signing it, and extend the X.509 parser to refuse 
> > certificates that have a tag that's present in dbx.
> 
> Why would Microsoft put a hash of something into dbx which they
> haven't signed?  Wouldn't this make them subject to a
> denial-of-service attack on their platform if they revoke something
> with surprising consequences?

? The entire point is that the key is in a binary that Microsoft have 
signed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
