Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaLHLY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:24:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38681 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbaLHLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:24:57 -0500
Message-ID: <54858A55.8010005@ti.com>
Date: Mon, 8 Dec 2014 16:54:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>, Kevin Hilman <khilman@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ARM / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <2407638.dfZGaT4vm1@vostro.rjw.lan>
In-Reply-To: <2407638.dfZGaT4vm1@vostro.rjw.lan>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2014 08:20 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere in the code under
> arch/arm/ (the defconfig files will be modified later).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  arch/arm/kernel/perf_event.c       |    2 +-
>  arch/arm/mach-davinci/pm_domain.c  |    2 +-

Acked-by: Sekhar Nori <nsekhar@ti.com>

for the mach-davinci change. I have nothing conflicting queued, so feel
free to take this through your tree.

Thanks,
Sekhar

