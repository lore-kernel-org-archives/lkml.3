Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3JAMsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:48:52 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34537 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3JAMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:48:51 -0400
Date: Tue, 1 Oct 2013 09:48:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf autodep: Remove strlcpy feature check, add __weak
 strlcpy implementation
Message-ID: <20131001124842.GB2920@ghostprotocols.net>
References: <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
 <20131001113456.GA31331@gmail.com>
 <20131001120455.GA8001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001120455.GA8001@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 01, 2013 at 02:04:55PM +0200, Ingo Molnar escreveu:
> So there's more speedups possible I think, for example we could construct 
> an 'optimistic' testcase that is generated live and includes a 
> concatenation of all the testcases.
> 
> If the build of that file succeeds then we have a really efficient 
> fast-path both in the first-build and in the repeat-build case.
> 
> If that build fails then we do the more finegrained feature check.
> 
> Thoughts?

Lets get what you have merged and continue from there ;-)
 
- Arnaldo
