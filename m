Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3EaMu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:50:29 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39213 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:50:22 -0400
Date: Fri, 31 May 2013 14:50:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org,
        bp@alien8.de, paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        jbohac@suse.cz, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] nohz: Prevent broadcast source from stealing
 full dynticks timekeeping duty
Message-ID: <20130531125018.GA8791@gmail.com>
References: <tip-81e747d2ccfa9faa2b10507dca9d4b42796c561e@git.kernel.org>
 <20130531124930.GB5932@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531124930.GB5932@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, May 31, 2013 at 05:43:25AM -0700, tip-bot for Frederic Weisbecker wrote:
> > Commit-ID:  81e747d2ccfa9faa2b10507dca9d4b42796c561e
> > Gitweb:     http://git.kernel.org/tip/81e747d2ccfa9faa2b10507dca9d4b42796c561e
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Tue, 28 May 2013 15:29:03 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 31 May 2013 11:33:36 +0200
> > 
> > nohz: Prevent broadcast source from stealing full dynticks timekeeping duty
> 
> Hi Ingo,
> 
> Sorry I made several versions of posting and pull requests and it probably
> became confusing.
> 
> This patch was dropped in the latest version (nohz:timers/urgent-for-tip-v2)
> and got replaced by 02afeab42700a66a52aaedd21bcef0cd1994f715
> ("tick: Remove useless timekeeping duty attribution to broadcast source").
> 
> I hope you can still swap these.
> 
> The other commits are fine.

I zapped 81e747d - please double check it: does tip:timers/urgent look 
good to you now?

Thanks,

	Ingo
