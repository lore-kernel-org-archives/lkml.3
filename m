Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3BUTK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:10:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3BUTK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:10:26 -0500
Date: Thu, 21 Feb 2013 14:10:09 -0500
From: Peter Jones <pjones@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130221191009.GD20629@fenchurch.internal.datastacks.com>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <567.1361470653@warthog.procyon.org.uk>
 <CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com>
 <20130221183445.GB20629@fenchurch.internal.datastacks.com>
 <CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:56:44AM -0800, Linus Torvalds wrote:
> On Thu, Feb 21, 2013 at 10:34 AM, Peter Jones <pjones@redhat.com> wrote:
> > On Thu, Feb 21, 2013 at 10:25:47AM -0800, Linus Torvalds wrote:
> >>  - why do you bother with the MS keysigning of Linux kernel modules to
> >> begin with?
> >
> > This is not actually what the patchset implements.  All it's done here
> > is using PE files as envelopes for keys.  The usage this enables is to
> > allow for whoever makes a module (binary only or merely out of tree for
> > whatever reason) to sign it and vouch for it themselves.  That could
> > include, for example, a systemtap module.
> 
> Umm. And which part of "We already support that, using standard X.509
> certificates" did we suddenly miss?
> 
> So no. The PE file thing makes no sense what-so-ever. What you mention
> we can already do, and we already do it *better*.

It's certainly true that we can use x509 signatures to chain trust from
x509 keys to other x509 keys, but when we do, we don't get to use the
hardware as the root of trust with any CA that actually *exists*.

-- 
        Peter
