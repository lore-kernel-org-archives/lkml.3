Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3KULad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:30:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43569 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab3KULaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:30:22 -0500
Date: Thu, 21 Nov 2013 12:30:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121113014.GA26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121111744.GA27513@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 12:17:44PM +0100, Ingo Molnar wrote:
> > However, now that I think of it, the naming is kinda imprecise 
> > having only "kernel" in it - it only denotes that it is a library of 
> > stuff that has grown in the kernel.
> > 
> > So how about
> > 
> > tools/lib/ktools/
> > tools/lib/kutils/
> > tools/lib/kernel-tools/
> > tools/lib/kernel-utils/
> > ...
> > 
> > and
> > 
> > libktools.so
> > libkutils.so
> > ...
> > 
> > ?
> > 
> > I'd prefer ktools as in the tools/ directory of the kernel repo.
> 
> So what does each name mean, what would they be used for and what's 
> the difference between them?

Oh no, I'm only proposing multiple libraries but multiple names to
choose *only* *one* from them - the one which we think fits best.

Basically I wanna say: "this is the library of tools which grew in the
tools/ directory of the kernel repo".

Thus I'm proposing

	tools/lib/ktools/

as a path and

	libktools.so

as a library name, because, IMHO, this name is closer to the reality.

tools/lib/kernel/ is also ok - it does not describe the collection of
functionality that precisely, IMHO, that's all.

Am I even making sense here?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
