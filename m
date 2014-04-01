Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaDARbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:31:34 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55727 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDARbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <533AF612.8020505@zytor.com>
References: <20140401082757.GA23451@gmail.com>
	<CA+55aFzKCVnqYussDpt8Fkoi28SthKRd3oKnSW4GnED+s6QdVQ@mail.gmail.com>
	<533AF612.8020505@zytor.com>
Date: Tue, 1 Apr 2014 10:31:31 -0700
X-Google-Sender-Auth: wTCxK6gri1e4IWbn83Z3UekIHgE
Message-ID: <CA+55aFx+8x+mh=iOfg2Yz6XBwG-Otw+wegLrP67uppERuC9WBw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/platforms for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 10:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
>>  (a) people don't know about, so asking people about it is f*cking
>> retarded to begin with
>
> Well, that is why it is an EXPERT option.

That's a cop-out. Because if you're *not* an expert, now it won't ask
about it, but it will just enable it because it's "default y".

So you got rid of the question, but you silently enabled the code THAT
MAKES NO SENSE FOR 99.9% of all users.

When I do "make oldconfig" on all my machines I sure as hell don't
suddenly want to find some driver that makes no sense in my
configuration.

See? It's stupid. It's wrong. It's *bad*.

And I'm not pulling stupid and wrong things (ok, well, I probably do
pull bad stuff all the time, but at least not intentionally and
knowingly).

              Linus
