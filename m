Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaIOP6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:58:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40988 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaIOP57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:57:59 -0400
Date: Mon, 15 Sep 2014 16:56:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
Message-ID: <20140915155656.GA29744@arm.com>
References: <cover.1410632834.git.joe@perches.com>
 <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 07:31:12PM +0100, Joe Perches wrote:
> Use the more common pr_warn.
> 
> Other miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/include/asm/syscall.h   |  8 ++++----
>  arch/arm/kernel/atags_parse.c    |  2 +-
>  arch/arm/kernel/hw_breakpoint.c  | 18 +++++++++---------
>  arch/arm/kernel/irq.c            |  4 ++--
>  arch/arm/kernel/perf_event_cpu.c |  4 ++--
>  arch/arm/kernel/smp.c            |  2 +-
>  arch/arm/kernel/unwind.c         | 24 ++++++++++++------------
>  arch/arm/mm/idmap.c              |  2 +-
>  arch/arm/mm/mmu.c                |  4 ++--
>  9 files changed, 34 insertions(+), 34 deletions(-)

It's Russell's call on this, but it really looks like more trouble than it's
worth imo. Having git blame identify the person who wrote the original code
is considerably more useful than being pointed at somebody making cosmetic
changes.

Will
