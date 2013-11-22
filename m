Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3KVPne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:43:34 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49890 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:43:33 -0500
Date: Fri, 22 Nov 2013 16:43:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122154317.GB15636@gmail.com>
References: <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122145756.GB11305@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122145756.GB11305@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Lets experiment at having things at the right granularity, even if 
> it involves many, directly linked, like libperf.a, libraries, one at 
> a time, starting with fskapi (or whatever name ends up being 
> preferred for this initial one).

That's fine with me - what I stood up against was the idea to merge 
into a single place things like the Git helpers, cmdline/option 
parser, etc.

The naming problem is mostly non-existent if the concepts are kept 
nicely separate: the best name for the debugfs bits is probably 
tools/lib/debugfs/, the best name for command line option parser is 
tools/lib/cmdline/, the best name for trace event parsing is 
tools/lib/traceevents/ [hey, we already have that one in the right 
place! ;-)], etc.

Thanks,

	Ingo
