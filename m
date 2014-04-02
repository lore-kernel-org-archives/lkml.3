Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaDBS5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:57:44 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53861 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbaDBS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140402144219.4cafbe37@gandalf.local.home>
References: <20140402144219.4cafbe37@gandalf.local.home>
Date: Wed, 2 Apr 2014 11:57:41 -0700
X-Google-Sender-Auth: Yeb9-XKSeFNObBgplZSUNNiOvbQ
Message-ID: <CA+55aFzCGQ-jk8ar4tiQEHCUoOPQzr-Mz+-LsPHCWZKryXZquQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 11:42 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> The response is:
>
> "Generic terms are generic, not the first user owns them."

And by "their" you mean Kay Sievers.

Key, I'm f*cking tired of the fact that you don't fix problems in the
code *you* write, so that the kernel then has to work around the
problems you cause.

Greg - just for your information, I will *not* be merging any code
from Kay into the kernel until this constant pattern is fixed.

This has been going on for *years*, and doesn't seem to be getting any
better. This is relevant to you because I have seen you talk about the
kdbus patches, and this is a heads-up that you need to keep them
separate from other work. Let distributions merge it as they need to
and maybe we can merge it once it has been proven to be stable by
whatever distro that was willing to play games with the developers.

But I'm not willing to merge something where the maintainer is known
to not care about bugs and regressions and then forces people in other
projects to fix their project. Because I am *not* willing to take
patches from people who don't clean up after their problems, and don't
admit that it's their problem to fix.

Kay - one more time: you caused the problem, you need to fix it. None
of this "I can do whatever I want, others have to clean up after me"
crap.

                 Linus
