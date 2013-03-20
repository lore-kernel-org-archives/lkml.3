Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3CTQw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3CTQw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:52:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <21286.1363716700@warthog.procyon.org.uk>
References: <21286.1363716700@warthog.procyon.org.uk> <20130318131224.43ebcf542e6dea358f546198@canb.auug.org.au> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com> <567.1361470653@warthog.procyon.org.uk> <CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com> <20130221183445.GB20629@fenchurch.internal.datastacks.com> <CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Wed, 20 Mar 2013 16:52:39 +0000
Message-ID: <2731.1363798359@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > David, if I do remove it, are there other patches in your pekey tree that
> > are still going forward?
> 
> No.

Well, maybe.  But feel free to drop it anyway for the moment.

David
