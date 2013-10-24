Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3JXTq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:46:57 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:36629 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3JXTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:46:56 -0400
Date: Thu, 24 Oct 2013 16:46:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131024194647.GF4998@ghostprotocols.net>
References: <20131024075813.GA26929@gmail.com>
 <1382604360.5283.9.camel@pippen.local.home>
 <CAGdX0WG1gmC-ZXn5BFRMD5FM2r5d3oxvDU61-xFrT90badv3tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WG1gmC-ZXn5BFRMD5FM2r5d3oxvDU61-xFrT90badv3tg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 24, 2013 at 08:11:36PM +0800, Jovi Zhangwei escreveu:
> I admit there have many places need to cleanup in ktap code, and there
> also have a long todo list, I will finish it before start review process.
> 
> Again, really sorry for this, please forgive me this mistake.

Just go eroding it, try to figure out things that could be useful on its
own, find the right place in the tree, send a flow of small self
contained patches that comes with tooling that uses whatever new kernel
feature that is added.

I think that even if you just add a 'perf test' entry that shows how the
new feature should be used by tooling, exercising it and checking its
results, so that every time people try 'perf test' it gets re verified,
that would be ok when no other tools/ living source code exercises it.

- Arnaldo
