Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab3BZEph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:45:37 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49962 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab3BZEpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:45:32 -0500
Date: Mon, 25 Feb 2013 23:45:21 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226044521.GC12906@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
	keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:25:55PM +1000, Dave Airlie wrote:
> 
> Its a simple argument, MS can revoke our keys for whatever reason,
> reducing the surface area of reasons for them to do so seems like a
> good idea. Unless someone can read the mind of the MS guy that
> arbitrarily decides this in 5 years time, or has some sort of signed
> agreement, I tend towards protecting the users from having their Linux
> not work anymore, because we were scared of a PE loader in the kernel.

If Microsoft will revoke keys for whatever reason they want, without
any regard to the potential PR and legal consequences to Microsoft,
there's absolutely **nothing** you can do, short of choosing to use
more open hardware (for example, like the Chromebook Pixel).

If you're that terrified of the completely arbitrary and capricious
Microsoft guy having us by the short hairs, why aid and abet Microsoft
control-freak model?

						- Ted
