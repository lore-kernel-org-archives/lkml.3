Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3BZDCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:02:00 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35301 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3BZDB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:01:59 -0500
Date: Mon, 25 Feb 2013 19:02:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226030249.GB23834@kroah.com>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226023332.GA29282@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:33:32AM +0000, Matthew Garrett wrote:
> On Mon, Feb 25, 2013 at 04:59:55PM -0800, Greg KH wrote:
> 
> > Wait right here.  This is NOT mandated by UEFI, nor by anyone else.  It
> > might be a nice thing that some people and companies want to implement,
> > but please don't think that some external entity is requiring that Linux
> > implement this, that is not true.
> 
> Oh, come on Greg. Allowing unsigned modules allows loading arbitrary 
> code into the kernel, and allowing arbitrary code into the kernel means 
> that the kernel can be used to directly boot a modified copy of the 
> Windows kernel. Avoiding that scenario is *explicitly* mandated by 
> Microsoft.

Then why is the signed shim is currently being used by successfully by
distros that do not use signed kernel modules?

> We can avoid it by either not using Microsoft as the root of 
> trust or by requiring explicit key installation during the OS install 
> process, but both of those make OS installation more difficult. If we 
> want Linux to Just Work out of the box on Microsoft-certified hardware, 
> this is one of the rules we have to live by.

I don't see that being required in the wording for the Microsoft signing
authority, and in personal discussions with them, they say it would be
nice, but they can't force the issue.  Where does it say this in the
agreement specifically?

thanks,

greg k-h
