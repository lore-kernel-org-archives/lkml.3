Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3HQPLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 11:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab3HQPLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 11:11:52 -0400
Date: Sat, 17 Aug 2013 17:05:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, gaolong@kylinos.com.cn,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [tip:sched/core] sched: Fix the theoretical signal_wake_up()
	vs. schedule() race
Message-ID: <20130817150509.GA26817@redhat.com>
References: <20130813143325.GA5541@redhat.com> <tip-e4c711cfd32f3c74a699af3121a3b0ff631328a7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e4c711cfd32f3c74a699af3121a3b0ff631328a7@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, tip-bot for Oleg Nesterov wrote:
>
> Commit-ID:  e4c711cfd32f3c74a699af3121a3b0ff631328a7
> Gitweb:     http://git.kernel.org/tip/e4c711cfd32f3c74a699af3121a3b0ff631328a7
> Author:     Oleg Nesterov <oleg@redhat.com>
> AuthorDate: Tue, 13 Aug 2013 16:33:25 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 16 Aug 2013 17:44:54 +0200
>
> sched: Fix the theoretical signal_wake_up() vs. schedule() race

Ingo, thanks.

But fyi, this is already merged as e0acd0a6 in Linus's tree.

Oleg.

