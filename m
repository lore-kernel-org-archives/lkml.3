Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaCDWMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:12:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:37591 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaCDWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:12:09 -0500
Date: Tue, 4 Mar 2014 23:12:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-mips@linux-mips.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] sched: Remove unused mc_capable() and
 smt_capable()
In-Reply-To: <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403042311480.18573@ionos.tec.linutronix.de>
References: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2014, Bjorn Helgaas wrote:

> Remove mc_capable() and smt_capable().  Neither is used.
> 
> Both were added by 5c45bf279d37 ("sched: mc/smt power savings sched
> policy").  Uses of both were removed by 8e7fbcbc22c1 ("sched: Remove stale
> power aware scheduling remnants and dysfunctional knobs").
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  arch/arm/include/asm/topology.h      |    3 ---
>  arch/ia64/include/asm/topology.h     |    1 -
>  arch/mips/include/asm/topology.h     |    4 ----
>  arch/powerpc/include/asm/topology.h  |    1 -
>  arch/sparc/include/asm/topology_64.h |    2 --
>  arch/x86/include/asm/topology.h      |    6 ------
>  6 files changed, 17 deletions(-)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
