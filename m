Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaBXHHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:07:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBXHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:07:40 -0500
Date: Mon, 24 Feb 2014 08:07:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, leiwen@marvell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched, nohz: Exclude isolated cores from load
 balancing
Message-ID: <20140224070731.GV9987@twins.programming.kicks-ass.net>
References: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
 <CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:11:05AM +0800, Lei Wen wrote:
> How about use the API as cpumask_test_and_clear_cpu?
> Then below one line is enough.

Its more expensive.

