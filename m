Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaEUCku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:40:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:36825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaEUCkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:40:49 -0400
Date: Wed, 21 May 2014 11:40:52 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, amirv@mellanox.com,
        bhutchings@solarflare.com, yevgenyp@mellanox.com,
        David Miller <davem@davemloft.net>, ogerlitz@mellanox.com,
        eyalpe@mellanox.com
Subject: Re: [tip:irq/core] genirq: Provide !SMP stub for
 irq_set_affinity_notifier()
In-Reply-To: <tip-f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1405211137460.24449@ionos.tec.linutronix.de>
References: <1400597820-30685-1-git-send-email-amirv@mellanox.com> <tip-f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Tue, 20 May 2014, tip-bot for Eyal Perry wrote:

> Commit-ID:  f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
> Gitweb:     http://git.kernel.org/tip/f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
> Author:     Eyal Perry <eyalpe@mellanox.com>
> AuthorDate: Tue, 20 May 2014 17:57:00 +0300
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 21 May 2014 11:31:51 +0900
> 
> genirq: Provide !SMP stub for irq_set_affinity_notifier()
> 
> Instead of requiring each consumer of the IRQ affinity notifier to have
> themselves be explicitly dependent on CONFIG_SMP, make the definition of
> struct irq_affinity_notify to exist independently of that config option
> and introduce a stub for irq_set_affinity_notifier() under non SMP
> configuration.
> 
> Fixes: 2eacc23 ("net/mlx4_core: Enforce irq affinity changes
> immediatly")

if you want to pick that up into net, it's available as a single
commit in

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-net

for your consumption.

Thanks,

	tglx
