Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbaH0UZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:25:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63469 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935598AbaH0UZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:25:46 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tero Kristo <t-kristo@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <j-keerthy@ti.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH V2 4/7] ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
References: <1408715373-25791-1-git-send-email-nm@ti.com>
	<1409165694-26568-1-git-send-email-nm@ti.com>
Date: Wed, 27 Aug 2014 13:25:43 -0700
In-Reply-To: <1409165694-26568-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Wed, 27 Aug 2014 13:54:54 -0500")
Message-ID: <7h1ts1bry0.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> powerdomain configuration in OMAP is done using PWRSTCTRL register for
> each power domain. However, PRCM lets us write any value we'd like to
> the logic and power domain target states, however the SoC integration
> tends to actually function only at a few discrete states. These valid
> states are already in our powerdomains_xxx_data.c file.
>
> So, provide a function to easily query valid low power state that the
> power domain is allowed to go to.
>
> Based on work originally done by Jean Pihet <j-pihet@ti.com>
> https://patchwork.kernel.org/patch/1325091/ . There is no attempt to
> create a new powerdomain solution here, except fixing issues seen
> attempting invalid programming attempts. Future consolidation to the
> generic powerdomain framework should consider this requirement as
> well.
>
> Similar solutions have been done in product kernels in the past such
> as:
> https://android.googlesource.com/kernel/omap.git/+blame/android-omap-panda-3.0/arch/arm/mach-omap2/pm44xx.c
>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>
> Not posting the entire series again and updating just this patch..
>
> V2: drop BUG in favor of WARN, picked up Santosh and Kevin's acks.

Looks good, thanks,

Kevin
