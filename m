Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3BZCdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:33:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45602 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3BZCdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:33:40 -0500
Date: Tue, 26 Feb 2013 02:33:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226023332.GA29282@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226005955.GA19686@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:59:55PM -0800, Greg KH wrote:

> Wait right here.  This is NOT mandated by UEFI, nor by anyone else.  It
> might be a nice thing that some people and companies want to implement,
> but please don't think that some external entity is requiring that Linux
> implement this, that is not true.

Oh, come on Greg. Allowing unsigned modules allows loading arbitrary 
code into the kernel, and allowing arbitrary code into the kernel means 
that the kernel can be used to directly boot a modified copy of the 
Windows kernel. Avoiding that scenario is *explicitly* mandated by 
Microsoft. We can avoid it by either not using Microsoft as the root of 
trust or by requiring explicit key installation during the OS install 
process, but both of those make OS installation more difficult. If we 
want Linux to Just Work out of the box on Microsoft-certified hardware, 
this is one of the rules we have to live by.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
