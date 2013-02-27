Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab3B0PYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:24:46 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50258 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab3B0PYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:24:45 -0500
Date: Wed, 27 Feb 2013 10:24:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Jones <pjones@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130227152429.GA5609@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Jones <pjones@redhat.com>, Dave Airlie <airlied@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <20130226165451.GE32160@fenchurch.internal.datastacks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226165451.GE32160@fenchurch.internal.datastacks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:54:51AM -0500, Peter Jones wrote:
> No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
> we've got a contract with them, and it says they provide the signing
> service, and under circumstances where the thing being signed is found
> to enable malware that circumvents Secure Boot

The question is what does "malware that circuments Secure Boot" mean?
Does starting up a hacked KVM and running Windows 8 under KVM so that
malare can be injected count as circumenting Secure Boot?  If so, will
you have to disable KVM, too?

What if someone implements a virtualization bootkit for Windows 8.
Will they revoke their own key?  Somehow, I doubt that....

						- Ted
