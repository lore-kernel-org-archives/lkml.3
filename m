Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaFGDKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:10:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaFGDKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:10:51 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
From: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <20140606082420.GA28241@nazgul.tnic>
Date: Fri, 6 Jun 2014 20:09:46 -0700
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@gentoo.org" <kernel@gentoo.org>,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6385EF0C-1551-4D38-8F00-94258CA5AF4C@zytor.com>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org> <20140427120820.GC22116@gmail.com> <20140430215606.GD17745@localhost.localdomain> <20140507164014.GB16034@gmail.com> <20140606081726.GT6758@twins.programming.kicks-ass.net> <20140606082420.GA28241@nazgul.tnic>
To: Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB debug port is nice once you get it to work.  Assumes they haven't done anything clever like hide the special port behind a hub...

Sent from my tablet, pardon any formatting problems.

> On Jun 6, 2014, at 1:24, Borislav Petkov <bp@alien8.de> wrote:
> 
>> On Fri, Jun 06, 2014 at 10:17:26AM +0200, Peter Zijlstra wrote:
>> Hopefully the EFI pstore thing will work out, but I've already heard
>> that can wear out very quickly and render your machine a brick :-(
> 
> And not only that - write speed is awfully low. I hear you might be ok
> to record an oops or so. Continuous debug output, not so much.
> 
>> Me, I simply refuse to work on machines if they don't have a serial
>> line, but in general that's not a tenable position I suppose :/
> 
> Well, with all the other crap they put in modern machines, how hard it
> is to put a goddam stupid serial line out everywhere...? WTF do I need a
> goddam adaptive keyboard and other idiotic bling-bling if I can't have a
> simple serial line for debugging... Blergh.
