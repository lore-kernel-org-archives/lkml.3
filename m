Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaKRCv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:51:28 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:37879 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaKRCv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141118023930.GA2871@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141117170359.GA1382@redhat.com>
	<CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
	<20141118020959.GA2091@redhat.com>
	<CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
	<20141118023930.GA2871@redhat.com>
Date: Mon, 17 Nov 2014 18:51:25 -0800
X-Google-Sender-Auth: 1iBFajSzcYXmk8O4seosXiBH_js
Message-ID: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 6:39 PM, Dave Jones <davej@redhat.com> wrote:
>
> So it could be that I'm just generating a lot more load now.
> I could drop that back down and see if it 'goes away' or at least
> happens less, but it strikes me that there's something here that needs
> fixing regardless.

Oh, absolutely. It's more a question of "maybe what changed can give us a clue".

But if it' something like "more load", that's not going to help
pinpoint, and you might be better off just doing the all-cpu-backtrace
thing and hope that gives some pattern to appreciate..

                  Linus
