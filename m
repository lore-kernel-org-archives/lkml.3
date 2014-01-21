Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAUTRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:17:01 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:55949 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaAUTQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <20131126003919.GT14725@sirena.org.uk>
References: <20131125174037.GR14725@sirena.org.uk>
	<CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
	<20131126003919.GT14725@sirena.org.uk>
Date: Tue, 21 Jan 2014 11:16:57 -0800
X-Google-Sender-Auth: zpSk8SOAnXJWLoOGgtAVc9hTz1w
Message-ID: <CA+55aFxX3odNLBt1L6iAPGybekioqaW3SREmXywd_jnz_tDBeQ@mail.gmail.com>
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 4:39 PM, Mark Brown <broonie@kernel.org> wrote:
>
> If you're OK with octopus merges for things like this I'll definitely
> take another look at using them, the enormous stack of merge commits
> always looks noisy to me in the logs and pull requests and for things
> like driver updates there's unlikely to be much doubt about which branch
> it was if there's a problem.

Christ. When you start doing octopus merges, you don't do it by half
measures, do you?

I just pulled the sound updates from Takashi, and as a result got your
merge commit 2cde51fbd0f3. That one has 66 parents.

That kind of merge either needs to be split up, or gitk needs to be
made better about visualizing it, because it ends up being *so* wide
that the history is hard to read.

I think you'll find that having that many parents also breaks old
versions of git.

Anyway, I'd suggest you try to limit octopus merges to ~15 parents or
less to make the visualization tools not go crazy.  Maybe aim for just
10 or so in most cases.

It's pulled, and it's fine, but there's clearly a balance between
"octopus merges are fine" and "Christ, that's not an octopus, that's a
Cthulhu merge".

                Linus
