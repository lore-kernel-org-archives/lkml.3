Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBXDSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:18:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaBXDSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:18:46 -0500
Message-ID: <1393211920.5599.25.camel@marge.simpson.net>
Subject: Re: [tip:sched/core] sched, nohz: Exclude isolated cores from load
 balancing
From: Mike Galbraith <mgalbraith@suse.de>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, leiwen@marvell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Mon, 24 Feb 2014 04:18:40 +0100
In-Reply-To: <CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
References: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
	 <CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 10:11 +0800, Lei Wen wrote:

> How about use the API as cpumask_test_and_clear_cpu?
> Then below one line is enough.

Yeah.

> +               if (likely(cpumask_test_and_clear_cpu(cpu,
> nohz.idle_cpus_mask))) {
> 
> And I am not pretty sure whether we need such test here.

It was born because I watched me wreck nohz.nr_cpus :)

-Mike

