Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaLIWwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:52:17 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:59935 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaLIWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:52:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412092329490.16275@nanos>
References: <1418114172.4779.22.camel@leyfoon-vm>
	<CA+55aFx9FETsUvn4EmYJz-v1uK8He0FRqFqHMRQ8aiEZ6mQwGA@mail.gmail.com>
	<alpine.DEB.2.11.1412092329490.16275@nanos>
Date: Tue, 9 Dec 2014 14:52:12 -0800
X-Google-Sender-Auth: pXxfn-igufQpYNjbuPUIy2svxK8
Message-ID: <CA+55aFytYNBRG43u-PGVt1J0pSbza=RasCvRHWLcaegarYJzug@mail.gmail.com>
Subject: Re: [GIT PULL] arch/nios2 for v3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 2:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> It's a bit sad that all the reviewed/acked-by information which has
> been sent throughout the review process is completely lost.

Yes. In general, it would probably be a great idea to just include
pointers to acks etc, and I can add them to the merge commit. Arnd's
ack got through simply because he replied to the pull request in time
before I pulled, but that's usually not really going to work, so just
having the maintainer gather up the acks and present them at pull time
would be a good idea.

                       Linus
