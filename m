Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781Ab3B0TeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:34:18 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50375 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760284Ab3B0TeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:34:16 -0500
Date: Wed, 27 Feb 2013 14:34:05 -0500
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
Message-ID: <20130227193405.GC14253@thunk.org>
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
References: <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <20130226165451.GE32160@fenchurch.internal.datastacks.com>
 <20130227152429.GA5609@thunk.org>
 <512E4409.2040907@genband.com>
 <20130227175947.GA16966@thunk.org>
 <512E5C9F.2050800@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E5C9F.2050800@genband.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 01:21:03PM -0600, Chris Friesen wrote:
> 
> I think it'd need to be "doesn't notice operationally when running
> the virtualized Windows install".
> 
> Anyone going through all the trouble to virtualize an existing
> install could probably arrange to have the target computer do the
> conversion at a time when nobody is likely to be around.

It shouldn't be all that hard to avoid doing a full-fledged
conversion.  I've in the pat managed to configure KVM so that a
particular installation of Windows could be run either natively or
under KVM.  The hard part would be to make Windows not notice the
change in device drivers necessary, so trying to make this work with
paravirtualization would be tricky.  But if you aren't shooting for a
full performance, it shouldn't be that hard.

That being said, if someone were being employed by the NSA to attack
Iran, or by the MSS to attack the US Federal Government, or simply by
a russian firm wanting to make $$$ selling Viagra, they'd probably try
to shoot for figuring out some way to surrepticiously install the
paravirtualization drivers into an existing Windows install.  But this
is not a fundamental theoretical difficulty; just a practical one.)

       	 	     		 	     	    - Ted
