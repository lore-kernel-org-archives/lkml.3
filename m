Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab3CLVyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:54:08 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40564 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3CLVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <7vppz45lz9.fsf@alter.siamese.dyndns.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
	<CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
	<20130312212027.GE14792@thunk.org>
	<CA+55aFwHJtOU4Qzt3XZsER165kTc5P0ATQP2wPHvuUiVic8bnA@mail.gmail.com>
	<7vppz45lz9.fsf@alter.siamese.dyndns.org>
Date: Tue, 12 Mar 2013 14:54:04 -0700
X-Google-Sender-Auth: fxkciU2-jmDVxko7xC_QD6Q41bk
Message-ID: <CA+55aFzWjfFjcRZXBO+edO7f66REA0pOsC3iZ2vYdHrkcovnHA@mail.gmail.com>
Subject: Re: linux-next: unneeded merge in the security tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 2:47 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> I agree that "--ff-only" thing is too strict and sometimes you would
> want to allow back-merges, but when you do allow such a back-merge,
> is there a reason you want it to be --no-signatures merge?  When a
> subtree maintainer decides to merge a stable release point from you
> with a good reason, I do not see anything wrong in recording that
> the resulting commit _did_ merge what you released with a signature.

No, there's nothing really bad with adding the signature to the merge
commit if you do make a merge. It's the fact that it currently makes a
non-ff merge when that is pointless that hurts.

That said, adding the signature from an upstream tag doesn't really
seem to be hugely useful. I'm not seeing much of an upside, in other
words. I'd *expect* that people would pick up upstream tags
regardless, no?

           Linus
