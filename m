Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3J0T77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:59:59 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:50882 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3J0T76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <526D6FF9.9020003@canonical.com>
References: <20131026121902.GA24890@gmail.com>
	<CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
	<526D62D8.8050001@canonical.com>
	<CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
	<526D6B6D.2000605@canonical.com>
	<CA+55aFz4Fd-dibRL0+VKxz3PhppasvqCU7E6ToW2AWfnsenP_w@mail.gmail.com>
	<526D6FF9.9020003@canonical.com>
Date: Sun, 27 Oct 2013 12:59:57 -0700
X-Google-Sender-Auth: 6QhQ_JoFPKI3fSr96rZXJIr5lok
Message-ID: <CA+55aFyud32TExCVaL-k5dCPqrEBD9AZd-st6ooziwZCy9HZDg@mail.gmail.com>
Subject: Re: [GIT PULL] locking fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 12:56 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>
> And this is why ww_ctx == NULL is now passed as an inline argument. :)

Well, more than that - the "optimization" has been done at the source
code level, so that the behavior is no longer a matter about how well
the compiler optimizes it any more.

I'm not complaining about the fix. I'm complaining about how the fix
was claimed to be due to a compiler bug. The "documentation" for the
fix (ie the commit message) was actively misleading.

               Linus
