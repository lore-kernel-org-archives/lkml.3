Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab3B0SAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:00:00 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50309 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab3B0R75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:59:57 -0500
Date: Wed, 27 Feb 2013 12:59:47 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Peter Jones <pjones@redhat.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130227175947.GA16966@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chris Friesen <chris.friesen@genband.com>,
	Peter Jones <pjones@redhat.com>, Dave Airlie <airlied@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <20130226165451.GE32160@fenchurch.internal.datastacks.com>
 <20130227152429.GA5609@thunk.org>
 <512E4409.2040907@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E4409.2040907@genband.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:36:09AM -0600, Chris Friesen wrote:
> ...
> At this point you've got a running infected Win8 install that is
> running on Secure Boot hardware but is actually running malware.
> 
> Admittedly this would be tricky to do reliably in a way that the
> user doesn't notice, so it may not actually be a real-world threat.

That's another thing which is extraordinarily vague.  What counts as
"user doesn't notice"?  If a whole bunch of kernel messages scroll by,
is that enough?  What if a Penguin jpg shows up for a minimum 5
seconds?  15 seconds?  30 seconds?

						- Ted


