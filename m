Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3CLWA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:00:29 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:33933 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab3CLWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=aeU6sCReqUNhldTTaeKRWEODHOa+VcUa
	PGB8BMwTGwnj+1qJ1FM0HUEpNDD1RF0424TME3+0i4KESv5XVsIb1g1MlbxdjGYV
	SENM9p6ijGHdqBYe9DMCdnZYFOu6jlmqm7gpVsE5cBAjiIYqugZ2rJzkLfNJ+IjU
	j7O4MCfzfk8=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: linux-next: unneeded merge in the security tree
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
 <20130312041641.GE18595@thunk.org>
 <CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
 <20130312212027.GE14792@thunk.org>
 <CA+55aFwHJtOU4Qzt3XZsER165kTc5P0ATQP2wPHvuUiVic8bnA@mail.gmail.com>
 <7vppz45lz9.fsf@alter.siamese.dyndns.org>
 <CA+55aFzWjfFjcRZXBO+edO7f66REA0pOsC3iZ2vYdHrkcovnHA@mail.gmail.com>
Date: Tue, 12 Mar 2013 15:00:24 -0700
In-Reply-To: <CA+55aFzWjfFjcRZXBO+edO7f66REA0pOsC3iZ2vYdHrkcovnHA@mail.gmail.com> (Linus
 Torvalds's message of "Tue, 12 Mar 2013 14:54:04 -0700")
Message-ID: <7vli9s5ldz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 3EC4677A-8B60-11E2-8FD2-26A52E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> That said, adding the signature from an upstream tag doesn't really
> seem to be hugely useful. I'm not seeing much of an upside, in other
> words. I'd *expect* that people would pick up upstream tags
> regardless, no?

Yes, their "git fetch" will auto-follow, but mergetag embedded in
the commit objects will give the history auditable trail the same
way as the merges you make your downstream.  You of course could
match out-of-line tags against back-merges and verify your merges
with mergetags, but you do not have to.
