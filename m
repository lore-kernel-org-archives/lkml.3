Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3EaM5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:57:40 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55412 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3EaM5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:57:16 -0400
Date: Fri, 31 May 2013 14:57:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org,
        bp@alien8.de, paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        jbohac@suse.cz, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] nohz: Prevent broadcast source from stealing
 full dynticks timekeeping duty
Message-ID: <20130531125711.GD5932@somewhere>
References: <tip-81e747d2ccfa9faa2b10507dca9d4b42796c561e@git.kernel.org>
 <20130531124930.GB5932@somewhere>
 <20130531125018.GA8791@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531125018.GA8791@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 02:50:18PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, May 31, 2013 at 05:43:25AM -0700, tip-bot for Frederic Weisbecker wrote:
> > > Commit-ID:  81e747d2ccfa9faa2b10507dca9d4b42796c561e
> > > Gitweb:     http://git.kernel.org/tip/81e747d2ccfa9faa2b10507dca9d4b42796c561e
> > > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > > AuthorDate: Tue, 28 May 2013 15:29:03 +0200
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Fri, 31 May 2013 11:33:36 +0200
> > > 
> > > nohz: Prevent broadcast source from stealing full dynticks timekeeping duty
> > 
> > Hi Ingo,
> > 
> > Sorry I made several versions of posting and pull requests and it probably
> > became confusing.
> > 
> > This patch was dropped in the latest version (nohz:timers/urgent-for-tip-v2)
> > and got replaced by 02afeab42700a66a52aaedd21bcef0cd1994f715
> > ("tick: Remove useless timekeeping duty attribution to broadcast source").
> > 
> > I hope you can still swap these.
> > 
> > The other commits are fine.
> 
> I zapped 81e747d - please double check it: does tip:timers/urgent look 
> good to you now?

Yep, but it misses 02afeab42700a66a52aaedd21bcef0cd1994f715.
