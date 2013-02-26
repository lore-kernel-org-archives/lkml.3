Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3BZTqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:46:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58399 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3BZTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:46:14 -0500
Date: Tue, 26 Feb 2013 19:46:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226194609.GB16640@srcf.ucam.org>
References: <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <87621esw1m.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87621esw1m.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:40:53PM +0100, Florian Weimer wrote:
> | No, there's no way to set the legacy boot as the default option.
> 
> <https://plus.google.com/100479847213284361344/posts/QhmBpn5GNE9>
> 
> So non-interactive booting of alternative operating systems is *not*
> supported.  This is way more restrictive than any x86 UEFI device I've
> heard of (even in the face of a potential revocation of the boot
> loader by Microsoft).

It's supported as long as you use Google's bootloader rather than a 
legacy one, but you're still stuck with either a 30-second boot delay or 
hitting ctrl+d and there's no way to install your own keys without 
disassembling the machine and physically disabling the write-protection 
on the firmware. It's certainly more hostile than any UEFI Secure Boot 
system I've found.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
