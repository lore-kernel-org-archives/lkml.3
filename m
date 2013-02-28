Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab3B1Ubq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:31:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52061 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3B1Ubp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:31:45 -0500
Date: Thu, 28 Feb 2013 20:31:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130228203136.GA9420@srcf.ucam.org>
References: <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <8738wgsweq.fsf@mid.deneb.enyo.de>
 <512F7B0E.1030404@genband.com>
 <20130228193023.GA8090@srcf.ucam.org>
 <87d2vkns4m.fsf@mid.deneb.enyo.de>
 <20130228195321.GA8769@srcf.ucam.org>
 <87zjyombla.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjyombla.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 09:23:45PM +0100, Florian Weimer wrote:
> * Matthew Garrett:
> > grub's running before ExitBootServices(), because otherwise it has no 
> > way to actually read anything off disk. Or draw to the screen.
> 
> Sorry, if Linux can read from the disk after ExitBootServices(), so
> can a boot loader.  Actually, we could boot Linux directly, with an
> initrd which contains a boot selector, and use kexec if the chosen
> kernel doesn't match the initial one.

"A bootloader" might be able to. grub can't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
