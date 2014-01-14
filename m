Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaANNj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:39:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:39:55 -0500
Date: Tue, 14 Jan 2014 14:39:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PATCH: UV/NMI Fix tip/bot/kbuild test robot problems
Message-ID: <20140114133945.GA7572@laptop.programming.kicks-ass.net>
References: <20140114042407.913800664@asylum.americas.sgi.com>
 <20140114042408.283595833@asylum.americas.sgi.com>
 <20140114110021.GV7572@laptop.programming.kicks-ass.net>
 <52D53B52.1030201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D53B52.1030201@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 05:27:46AM -0800, Mike Travis wrote:
> 
> 
> On 1/14/2014 3:00 AM, Peter Zijlstra wrote:
> > On Mon, Jan 13, 2014 at 10:24:09PM -0600, Mike Travis wrote:
> >> Fix some problems found by the kbuild test robot.
> >>
> >> Signed-off-by: Mike Travis <travis@sgi.com>
> >> Reviewed-by: Hedi Berriche <hedi@sgi.com>
> > 
> > In general it is best to actually mention the issues the patch cures,
> > otherwise review is impossible, /me stares hard at Hedi.
> > 
> 
> I can send an updated patch if required?  The issues were
> pretty trivial so I didn't think more info than the patch
> itself was needed.

It makes it impossible to say if what you did corresponds with what you
meant to do; let alone say if its the 'correct' way.

> Hopefully I don't get a lot more in the future (this was my
> first time), should I include the actual tipbot messages?

Sure.
