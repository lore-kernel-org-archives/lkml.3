Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3BUSZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:25:49 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48589 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab3BUSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:25:48 -0500
MIME-Version: 1.0
In-Reply-To: <567.1361470653@warthog.procyon.org.uk>
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<567.1361470653@warthog.procyon.org.uk>
Date: Thu, 21 Feb 2013 10:25:47 -0800
X-Google-Sender-Auth: buIvVKxap51zr9tXePEmWUHp5Fk
Message-ID: <CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:17 AM, David Howells <dhowells@redhat.com> wrote:
>
> There's a problem with your idea.

You continue to miss the big question:

 - why should the kernel care?

 - why do you bother with the MS keysigning of Linux kernel modules to
begin with?

Your arguments only make sense if you accept those insane assumptions
to begin with. And I don't.

           Linus
