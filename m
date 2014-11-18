Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaKRCVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:21:11 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62355 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRCVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:21:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141118020959.GA2091@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141117170359.GA1382@redhat.com>
	<CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
	<20141118020959.GA2091@redhat.com>
Date: Mon, 17 Nov 2014 18:21:08 -0800
X-Google-Sender-Auth: WvpiR_po65u6BLbZK_Q3nezWgSU
Message-ID: <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
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

On Mon, Nov 17, 2014 at 6:09 PM, Dave Jones <davej@redhat.com> wrote:
>
> After wasting countless hours rolling back to Fedora 20 and gcc 4.8.1,
> I saw the exact same trace on 3.17, so now I don't know what to think.

Uhhuh.

Has anything else changed? New trinity tests? If it has happened in as
little as ten minutes, and you don't recall having seen this until
about a week ago, it does sound like something changed.

But yeah, try the softlockup_all_cpu_backtrace, maybe there's a
pattern somewhere..

              Linus
