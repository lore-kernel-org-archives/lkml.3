Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3HUDeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:34:18 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49491 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3HUDeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:34:17 -0400
Subject: Re: [PATCH v3 trivial 0/7] Miscellaneous Trivialities
Date: Wed, 21 Aug 2013 03:32:02 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <trivial@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <0f201a86cef14399a093518c2743856f-mfwitten@gmail.com>
In-Reply-To: <1377044377.2737.87@driftwood>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
            <1377033602.2737.81@driftwood>
            <6a1db75a9ce0483b94e4c6b2989e547b-mfwitten@gmail.com>
            <1377044377.2737.87@driftwood>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 19:19:37 -0500, Rob Landley wrote:

> Because some people actually read the commit logs and changes that
> don't do anything add noise for no benefit? (Your fourth change was a
> single typo fix. The previous three changes _combined_ were less
> valuable than that single typo fix. Hence asking if we really needed
> three separate commits to accomplish something that didn't actually
> need to be done in the first place.)
> ...
> Actually my objection is that it's not worth the churn in the commit logs.

Naturally, we don't NEED three separate commits! Squash all of them
into one commit if that's something worth hissing about.

Do you need help with the relevant commands?

Because you are the former and current maintainer of large and active
projects, I'd expect you to *appreciate* the value of taking in
fine-grained patches for REVIEW (even if you don't appreciate their
sum total).

The patches have been written in a way to *ease* the job of the
maintainer in understanding the changes. The fact that you find each
patch ludicrously trivial is a GREAT sign, especially considering
that I sent them mainly to the maintainer of... *TRIVIAL* changes.

> But yeah, why would a guy listed in MAINTAINERS as caring about the
> Documentation directory pay attention to proposed changes to the
> Documentation directory? Madness. I'll butt out now...

Madness is thinking that it means something to have your name listed in
some file. You are the maintainer when people send you patches and pull
from your repo---that is, when people *like* working with you. That's it.
A name in a file is simply a starting point for those contributors who
may not know any better.

Don't take "your" position for granted.
