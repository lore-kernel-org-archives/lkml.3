Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab3BZDpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:45:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50766 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3BZDpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:45:31 -0500
Date: Tue, 26 Feb 2013 03:45:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226034526.GC30285@srcf.ucam.org>
References: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <20130226034031.GA26591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226034031.GA26591@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:40:31PM -0800, Greg KH wrote:

> What "vendor" is there in this case?  You released a signed shim, as did
> the Linux Foundation, and lots of distros are now using it, and there
> are absolutly no "orginization" behind a bunch of them.  Will your
> signed shim be revoked because a random PoC was posted somewhere that
> could be used with any kernel booted using it?

No, because the version I released doesn't allow you to boot stuff 
without there having been explicit end-user authorisation in advance. 
The LF loader is in the same situation. But no user-focused distribution 
is going to do that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
