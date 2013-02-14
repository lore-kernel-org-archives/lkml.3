Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089Ab3BNW6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:58:51 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:58607 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030306Ab3BNW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:58:50 -0500
Date: Thu, 14 Feb 2013 22:58:49 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Sebastien Guiriec <s-guiriec@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/9] ARM: omap2: include linux/errno.h in hwmod_reset
In-Reply-To: <1360882071-4072668-4-git-send-email-arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1302142258390.11016@utopia.booyaka.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-4-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013, Arnd Bergmann wrote:

> The newly created omap_hwmod_reset.c is missing an
> include of linux/errno.h in commit c02060d8 "ARM:
> OMAP4+: AESS: enable internal auto-gating during
> initial setup". It still works in omap2_defconfig,
> but not in all other combinations.
> 
> Without this patch, building allmodconfig results in:
> 
> arch/arm/mach-omap2/omap_hwmod_reset.c: In function 'omap_hwmod_aess_preprogram':
> arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: error: 'EINVAL' undeclared (first use in this function)
> arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: note: each undeclared identifier is reported only once for each function it appears in

Acked-by: Paul Walmsley <paul@pwsan.com>


- Paul
