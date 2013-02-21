Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3BUSD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:03:26 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36847 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3BUSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:03:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130221174955.GA20886@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<20130221174955.GA20886@srcf.ucam.org>
Date: Thu, 21 Feb 2013 10:03:20 -0800
X-Google-Sender-Auth: 7fyvFYXy0VrG-csdL-DMMrKg30Y
Message-ID: <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
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

On Thu, Feb 21, 2013 at 9:49 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Vendors want to ship keys that have been signed by a trusted party.
> Right now the only one that fits the bill is Microsoft, because
> apparently the only thing vendors love more than shitty firmware is
> following Microsoft specs.

Quite frankly, I doubt that anybody will ever care, plus getting me to
care about some vendor that ships external binary-only modules is
going to be hard as hell.

Plus quite frankly, signing random kernel vendor modules (indirectly)
with a MS key is f*cking stupid to begin with.

In other words, I really don't see why we should bend over backwards,
when there really is no reason to. It's adding stupid code to the
kernel only to encourage stupidities in other people.

Seriously, if somebody wants to make a binary module for Fedora 18 or
whatever, they should go to Red Hat and ask whether RH is willing to
sign their key. And the whole "no, we only think it makes sense to
trust MS keys" argument is so f*cking stupid that if somebody really
brings that up, I can only throw my hands up and say "whatever".

In other words, none of this makes me think that we should do stupid
things just to perpetuate the stupidity. And I don't believe in the
argument to begin with.

Besides, let's face it, Red Hat is going to sign the official nVidia
and AMD binary modules anyway. Don't even bother to pretend anything
else.

                         Linus
