Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaFFIYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:24:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48388 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaFFIYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:24:21 -0400
Date: Fri, 6 Jun 2014 10:24:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140606082420.GA28241@nazgul.tnic>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
 <20140430215606.GD17745@localhost.localdomain>
 <20140507164014.GB16034@gmail.com>
 <20140606081726.GT6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140606081726.GT6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 10:17:26AM +0200, Peter Zijlstra wrote:
> Hopefully the EFI pstore thing will work out, but I've already heard
> that can wear out very quickly and render your machine a brick :-(

And not only that - write speed is awfully low. I hear you might be ok
to record an oops or so. Continuous debug output, not so much.

> Me, I simply refuse to work on machines if they don't have a serial
> line, but in general that's not a tenable position I suppose :/

Well, with all the other crap they put in modern machines, how hard it
is to put a goddam stupid serial line out everywhere...? WTF do I need a
goddam adaptive keyboard and other idiotic bling-bling if I can't have a
simple serial line for debugging... Blergh.
