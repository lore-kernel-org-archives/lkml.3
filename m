Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaJLOcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:32:06 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42242 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJLOcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org>
	<CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com>
Date: Sun, 12 Oct 2014 10:32:01 -0400
X-Google-Sender-Auth: xQdKOPeEeH9waNVINZcoNL55sAg
Message-ID: <CA+55aFxdQZup2rF+zoKj+xzTwZ2jZGewc18SGVihRXprUFsgSw@mail.gmail.com>
Subject: Re: [GIT] Security subsystem upate for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>, Paul Moore <pmoore@redhat.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 10:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Give me a synopsis of what has changed and why I should pull.

Side note: this is not just for me personally (so that I have a better
overview of what is going on during the merge window), but also so
that I can make sure that my merge messages are informative and tell
people what I merged and why.

In a perfect world, people could just read my merge messages and get a
good overview of everything that has changed. But that depends on
maintainers giving me those nice summaries of what the big important
changes have been for that merge. I can, and occasionally do, try to
write something up myself, but quite frankly, subsystem maintainers
are just *so* much better positioned to give a good summary of what
has been going on, that I really want that.

Of course, sometimes the summary might just be "a few trivial fixes"
and then people who really want the details can just look at the
individual commits. At other times, maybe you'd want to go into more
detail about some subtle change. There's no fixed format, but it's
supposed to be a human-readable quick high-level overview of what the
merge brings in.

You can just do "git log --author=Torvalds --merges" to see examples
of what people send me. Some people explain more, some explain less, I
really don't have any hard requirements. But I do want to get *some*
overview.

                 Linus
