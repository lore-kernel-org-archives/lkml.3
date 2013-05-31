Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3EaKCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:02:17 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48058 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3EaKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:02:12 -0400
Date: Fri, 31 May 2013 12:02:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Bohac <jbohac@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Mike Galbraith <efault@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] nohz fixes
Message-ID: <20130531100207.GB30394@gmail.com>
References: <1369845580-15273-1-git-send-email-fweisbec@gmail.com>
 <20130530233847.GA29017@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530233847.GA29017@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, May 29, 2013 at 06:39:39PM +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the timers/urgent-for-tip branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	timers/urgent-for-tip
> 
> Please rather pull timers/urgent-for-tip-v2, it removes "nohz: Prevent 
> broadcast source from stealing full dynticks timekeeping duty" and 
> includes "tick: Remove useless timekeeping duty attribution to broadcast 
> source" instead, acked by Thomas.

Applied, thanks a lot Frederic!

	Ingo
