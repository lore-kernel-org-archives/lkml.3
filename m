Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3KXD3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:29:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42217 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3KXD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:29:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Rx5h3nT16T2d6LKZlTAM+JvfXZMo7H2U=
Date: Sat, 23 Nov 2013 22:29:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mvebu: fix some sparse warnings
Message-ID: <20131124032918.GV29241@titan.lakedaemon.net>
References: <1383814958-5272-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383814958-5272-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 05:02:38PM +0800, Jisheng Zhang wrote:
> This patch fixes conflicting types for 'set_cpu_coherent' and fixes the
> following sparse warnings.
> 
> arch/arm/mach-mvebu/system-controller.c:42:38:
> warning: symbol 'armada_370_xp_system_controller' was not declared. Should it be static?
> arch/arm/mach-mvebu/system-controller.c:49:38:
> warning: symbol 'orion_system_controller' was not declared. Should it be static?
> arch/arm/mach-mvebu/system-controller.c:67:6:
> warning: symbol 'mvebu_restart' was not declared. Should it be static?
> arch/arm/mach-mvebu/coherency.c:31:15:
> warning: symbol 'coherency_phys_base' was not declared. Should it be static?
> arch/arm/mach-mvebu/coherency.c:48:5:
> warning: symbol 'set_cpu_coherent' was not declared. Should it be static?
> arch/arm/mach-mvebu/coherency.c:123:12:
> warning: symbol 'coherency_init' was not declared. Should it be static?
> arch/arm/mach-mvebu/pmsu.c:38:5: warning:
> symbol 'armada_xp_boot_cpu' was not declared. Should it be static?
> arch/arm/mach-mvebu/pmsu.c:61:12: warning:
> symbol 'armada_370_xp_pmsu_init' was not declared. Should it be static?
> arch/arm/mach-mvebu/platsmp.c:49:13: warning:
> symbol 'set_secondary_cpus_clock' was not declared. Should it be static?
> arch/arm/mach-mvebu/platsmp.c:97:13: warning:
> symbol 'armada_xp_smp_prepare_cpus' was not declared. Should it be static?
> arch/arm/mach-mvebu/hotplug.c:24:12: warning:
> symbol 'armada_xp_cpu_die' was not declared. Should it be static?
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  arch/arm/mach-mvebu/coherency.c         | 1 +
>  arch/arm/mach-mvebu/coherency.h         | 4 +++-
>  arch/arm/mach-mvebu/common.h            | 1 -
>  arch/arm/mach-mvebu/hotplug.c           | 1 +
>  arch/arm/mach-mvebu/platsmp.c           | 4 ++--
>  arch/arm/mach-mvebu/pmsu.c              | 3 ++-
>  arch/arm/mach-mvebu/system-controller.c | 5 +++--
>  7 files changed, 12 insertions(+), 7 deletions(-)

Applied to mvebu/soc with Gregory's Ack.

thx,

Jason.
