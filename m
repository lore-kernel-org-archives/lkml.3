Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3KFWT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:19:57 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42244 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KFWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:19:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, daniel.lezcano@linaro.org,
        horms@verge.net.au, olof@lixom.net, tglx@linutronix.de
Subject: Re: [PATCH v2 00/03] clocksource: Consolidate SH and ARM mach-shmobile Kconfig bits
Date: Wed, 06 Nov 2013 23:20:25 +0100
Message-ID: <6099086.0MXoMDIj69@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131106110508.6806.48070.sendpatchset@w520>
References: <20131106110508.6806.48070.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thanks for the patches.

On Wednesday 06 November 2013 20:05:08 Magnus Damm wrote:
> clocksource: Consolidate SH and ARM mach-shmobile Kconfig bits (v2)
> 
> [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
> [PATCH v2 02/03] ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
> [PATCH v2 03/03] sh: Remove Kconfig entries for TMU, CMT and MTU2
> 
> This is V2 of the SH and ARM mach-shmobile clocksource Kconfig
> consolidation series.
> 
> By sharing Kconfig entires in drivers/clocksource/Kconfig we
> can get rid of duplicated bits that do not belong under arch/.
> 
> With this series applied it is possible to build the timer
> drivers for CMT, MTU2, TMU and STI in case of SH or ARM
> or when COMPILE_TEST is selected.
> 
> Since last time this has been broken out into 3 separate patches,
> where [PATCH v2 01/03] needs to go first, and the other patches
> can be merged any time after without any build or configuration
> issues.
> 
> Thanks to Olof and Simon for feedback! If I interpreted your
> ideas wrong please let me know and I will update.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

I like this approach.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  Written against renesas.git tag renesas-devel-v3.12-rc7-20131101
> 
>  arch/arm/mach-shmobile/Kconfig |   21 ---------------------
>  arch/sh/Kconfig                |   21 ---------------------
>  drivers/clocksource/Kconfig    |   30 ++++++++++++++++++++++++++++++
>  3 files changed, 30 insertions(+), 42 deletions(-)

-- 
Regards,

Laurent Pinchart

