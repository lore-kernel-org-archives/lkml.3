Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3HSHNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:13:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42569 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3HSHNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:13:45 -0400
Date: Mon, 19 Aug 2013 09:13:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, gaolong@kylinos.com.cn,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [tip:sched/core] sched: Fix the theoretical signal_wake_up() vs.
 schedule() race
Message-ID: <20130819071340.GB26184@gmail.com>
References: <20130813143325.GA5541@redhat.com>
 <tip-e4c711cfd32f3c74a699af3121a3b0ff631328a7@git.kernel.org>
 <20130817150509.GA26817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817150509.GA26817@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 08/16, tip-bot for Oleg Nesterov wrote:
> >
> > Commit-ID:  e4c711cfd32f3c74a699af3121a3b0ff631328a7
> > Gitweb:     http://git.kernel.org/tip/e4c711cfd32f3c74a699af3121a3b0ff631328a7
> > Author:     Oleg Nesterov <oleg@redhat.com>
> > AuthorDate: Tue, 13 Aug 2013 16:33:25 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 16 Aug 2013 17:44:54 +0200
> >
> > sched: Fix the theoretical signal_wake_up() vs. schedule() race
> 
> Ingo, thanks.
> 
> But fyi, this is already merged as e0acd0a6 in Linus's tree.

Missed that - I zapped this commit from the tip of 
sched/core, thanks Oleg!

	Ingo
