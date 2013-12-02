Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3LBOjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:39:43 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43315 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3LBOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:39:38 -0500
Date: Mon, 2 Dec 2013 15:39:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [GIT PULL] dynticks updates for 3.13
Message-ID: <20131202143927.GB6758@localhost.localdomain>
References: <1384181387-30194-1-git-send-email-fweisbec@gmail.com>
 <20131130135907.GA19027@gmail.com>
 <20131130141106.GA19997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131130141106.GA19997@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 03:11:06PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > Please pull the timers/core branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > > 	timers/core
> > > 
> > > It passed through 0-day testing. I'm proposing it for 3.13 just in case but I'm ok
> > > as well if you think it's too late and should be delayed for 3.14
> > 
> > Pulled into tip:timers/core, thanks Frederic!
> 
> Hm, I had to unpull it due to build failure:
> 
>   kernel/time/tick-sched.c:1054:2: error: too few arguments to function ‘tick_check_nohz’

Aie! I realize now that Wu Fengguang's 0-day testing reported me this on the 1st version
of this patchset. Then I got distracted with other things and forgot to fix it. And it didn't
warn me on the 2nd take to avoid spamming me.

Anyway, I'll fix this and resend.

> 
> I guess this means that it's better to rebase this series - at which 
> point the other complaints I had could be addressed as well?

Yeah sure.

Thanks!

> 
> Thanks,
> 
> 	Ingo
