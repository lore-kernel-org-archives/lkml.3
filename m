Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3BUUdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:33:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34354 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528Ab3BUUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:33:00 -0500
Date: Thu, 21 Feb 2013 20:32:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Jones <pjones@redhat.com>, David Howells <dhowells@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130221203254.GA25166@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <567.1361470653@warthog.procyon.org.uk>
 <CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com>
 <20130221183445.GB20629@fenchurch.internal.datastacks.com>
 <CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
 <20130221203119.GC23427@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221203119.GC23427@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 03:31:19PM -0500, Vivek Goyal wrote:
> On Thu, Feb 21, 2013 at 10:56:44AM -0800, Linus Torvalds wrote:
> 
> [..]
> > So no. The PE file thing makes no sense what-so-ever. What you mention
> > we can already do, and we already do it *better*.
> 
> IIUC, PE/COFF signature verification bits can be useful for verifying
> the signature of PE/COFF signed bzImage. This verification will be
> required before kexec decides to load the kernel.

Only if the kexec validation's being done in kernel. We'd need agreement 
on that before it's a justification.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
