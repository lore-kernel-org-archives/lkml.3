Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbbAZWPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:15:53 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47693 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwa1-pudNus+r=5EghpGkm33h--GZNND5UHt=ZKvP15Xw@mail.gmail.com>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
	<CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
	<CA+5PVA5RdtLyRiYerG=u--bRZQ87qU0EGf7kGPMiQs9_KB3hRw@mail.gmail.com>
	<CA+55aFwa1-pudNus+r=5EghpGkm33h--GZNND5UHt=ZKvP15Xw@mail.gmail.com>
Date: Mon, 26 Jan 2015 17:15:50 -0500
X-Google-Sender-Auth: aNhxF0IqDGpWxjmYmWgx6ztJWjE
Message-ID: <CA+5PVA7Hb1ppHFYA4wHC+uEyULk4m_7eX2FRNuisi1uOTagBEw@mail.gmail.com>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <gitster@pobox.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 4:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 26, 2015 at 1:07 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>> Or did I miss a way that git-apply can take a git patch and apply it
>> to a tree that isn't a git repo?
>
> Exactly. "git apply" works as a straight "patch" replacement outside
> of a git repository. It doesn't actually need a git tree to work.

Ah.  I had somehow missed that entirely.  Good to know for future reference.

> (Of course, "git apply" is _not_ a "patch" replacement in the general
> sense. It only applies context diffs - preferentially git style ones -
>  so no old-style patches etc need apply. And it's not
> replacement-compatible in a syntax sense either, in that while many of
> the options are the same, not all are etc etc).

Sure.  Though for the Fedora kernel builds, we tend to use git
formatted patches only anyway.  I might play around with this and see
how it works as the normal way to apply things.

josh
