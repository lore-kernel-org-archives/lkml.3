Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3KULRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:17:49 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41090 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KULRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:17:48 -0500
Date: Thu, 21 Nov 2013 12:17:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121111744.GA27513@gmail.com>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121100722.GA25459@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Nov 21, 2013 at 08:34:10AM +0100, Ingo Molnar wrote:
> > Ouch, the naming is horrible, what does 'lk' stand for?
> 
> "linux kernel" :-)
> 
> > Please rename it to something sensible before it spreads.
> > 
> > libkernel.so and tools/lib/kernel/ would be perfect I think.
> 
> However, now that I think of it, the naming is kinda imprecise 
> having only "kernel" in it - it only denotes that it is a library of 
> stuff that has grown in the kernel.
> 
> So how about
> 
> tools/lib/ktools/
> tools/lib/kutils/
> tools/lib/kernel-tools/
> tools/lib/kernel-utils/
> ...
> 
> and
> 
> libktools.so
> libkutils.so
> ...
> 
> ?
> 
> I'd prefer ktools as in the tools/ directory of the kernel repo.

So what does each name mean, what would they be used for and what's 
the difference between them?

Thanks,

	Ingo
