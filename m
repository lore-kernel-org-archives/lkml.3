Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3BUQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:58:51 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:35251 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3BUQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130221164244.GA19625@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
Date: Thu, 21 Feb 2013 08:58:45 -0800
X-Google-Sender-Auth: l3csW-kMs-vsAMpht_taxJhJAfA
Message-ID: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 8:42 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> There's only one signing authority, and they only sign PE binaries.

Guys, this is not a dick-sucking contest.

If you want to parse PE binaries, go right ahead.

If Red Hat wants to deep-throat Microsoft, that's *your* issue.  That
has nothing what-so-ever to do with the kernel I maintain. It's
trivial for you guys to have a signing machine that parses the PE
binary, verifies the signatures, and signs the resulting keys with
your own key. You already wrote the code, for chissake, it's in that
f*cking pull request.

Why should *I* care? Why should the kernel care about some idiotic "we
only sign PE binaries" stupidity? We support X.509, which is the
standard for signing.

Do this in user land on a trusted machine. There is zero excuse for
doing it in the kernel.

               Linus
