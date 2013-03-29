Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3C2SIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:08:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53075 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3C2SIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130329153831.GQ19488@kernel.dk>
References: <20130329153831.GQ19488@kernel.dk>
Date: Fri, 29 Mar 2013 11:08:40 -0700
X-Google-Sender-Auth: u-8WDmcZ9oTmmCPFe7jYWJwxtuc
Message-ID: <CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
Subject: Re: [GIT PULL] block fixes for 3.9-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 8:38 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Please pull! As per usual, it's tagged and signed.

No it's not.

You have a *branch* called for-linus that contains the commits you mention.

And then you have a *tag* called for-linus, but that's just my old
head that you've gone ahead and signed, which is entirely and utterly
pointless.

Christ, the amount of confusion in that tree.  Don't alias tags and
branches. And if you do, make it clear which one you mean by *saying*
so, ie "tags/for-linus", not just the ambiguous "for-linus". Now
you've confused yourself, and because of the ambiguity you never even
noticed, because the *branch* for-linus had the right commits.

Don't do this kind of thing. That branch is pointless, and just confused you.

                     Linus
