Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab3B1Taj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:30:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59208 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3B1Tai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:30:38 -0500
Date: Thu, 28 Feb 2013 19:30:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130228193023.GA8090@srcf.ucam.org>
References: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <8738wgsweq.fsf@mid.deneb.enyo.de>
 <512F7B0E.1030404@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512F7B0E.1030404@genband.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 09:43:10AM -0600, Chris Friesen wrote:
> On 02/28/2013 01:57 AM, Florian Weimer wrote:
> 
> >In any case, there's another reading of the UEFI Secure Boot
> >requirements: you may run any code you wish after calling
> >ExitBootServices().  That could be an unsigned, traditional GRUB.  But
> >this will not generally address the issue of dual-booting Windows 8 in
> >such a way that Windows sees that the device has enabled Microsoft
> >Secure Boot.
> 
> Would it be possible to have a signed bootloader that allows booting
> Win8 from within the secure environment, or it could exit the secure
> environment and run unsigned grub?

What would stop the unsigned grub from installing a firmware hook that 
lies about whether or not Secure Boot is enabled, and then booting 
Windows?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
