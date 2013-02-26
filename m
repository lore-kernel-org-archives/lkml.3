Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3BZDm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:42:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50780 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3BZDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:42:55 -0500
Date: Tue, 26 Feb 2013 03:42:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226034250.GB30285@srcf.ucam.org>
References: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:32:04PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 7:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > You're happy advising Linux vendors that they don't need to worry about
> > module signing because it's "not obvious" that Microsoft would actually
> > enforce the security model they've spent significant money developing
> > and advertising?
> 
> And you're happy shilling for a broken model?
>
> The fact is, the only valid user for the whole security model is to
> PROTECT THE USER.

The user Microsoft care about isn't running Linux. The user is running 
Windows, and someone's merely using Linux as a vector to launch their 
backdoored Windows kernel. How do Microsoft protect that user? They 
blacklist the signature used by that Linux bootloader. If we want to 
protect the user's ability to boot Linux, we need to protect the 
Windows users from having Linux used against them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
