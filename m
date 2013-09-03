Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab3ICQe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:34:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35923 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab3ICQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130903141322.GA27504@gmail.com>
References: <20130903141322.GA27504@gmail.com>
Date: Tue, 3 Sep 2013 18:34:54 +0200
X-Google-Sender-Auth: 8bwg2VKHHKNFPsS3a6D0UtEGvP4
Message-ID: <CAMuHMdWPE7OxWFNENe7qAx4+2rhMwbK6kG4LzXCxKMMKsxKM2w@mail.gmail.com>
Subject: Re: [GIT PULL] timers/nohz changes for v3.12
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 4:13 PM, Ingo Molnar <mingo@kernel.org> wrote:
> Please pull the latest timers-nohz-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus
>
>    HEAD: c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba nohz: Include local CPU in full dynticks global kick
>
> It mostly contains fixes and full dynticks off-case optimizations,
> by Frederic Weisbecker.
>
> NOTE: for some reason my pull request scripts failed to generate a proper
> diffstat so I've generated the shortlog and diffstat manually. All
> resulting mistakes are mine.

You forgot to push timers-nohz-for-linus, or it hadn't propagated from
ra.kernel.org to git.kernel.org?

git (1.7.9.5, Ubuntu 12.04LTS) doesn't seem to complain about missing or
stale branches on the remote, and just does something it thinks is right.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
