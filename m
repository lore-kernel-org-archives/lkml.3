Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935820Ab3BOMi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:38:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab3BOMi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:38:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/9] ARM: omap2: include linux/errno.h in hwmod_reset
Date: Fri, 15 Feb 2013 12:38:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Paul Walmsley <paul@pwsan.com>,
        Sebastien Guiriec <s-guiriec@ti.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-4-git-send-email-arnd@arndb.de> <20130214225142.GG11362@atomide.com>
In-Reply-To: <20130214225142.GG11362@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151238.32316.arnd@arndb.de>
X-Provags-ID: V02:K0:r8z8svnx0c7n3BbHRHFwuEY2SVMOogCoPkZfdcZa2QI
 Ygmt8VqxDByVcf0XgqSArbgfUjtgQm5pQ3jbfMc6Zwirt7utAr
 oZnO117noyeq/lw5HeO2Ro7W5gIryi8VckE8oNIwhDCa316fnF
 qO+dVS3av19b7a63xflf6NmM+5YqLreBpgWof7D4frD6gjjaMw
 8/GltPLRMl9c8L0mSY4YambexSfJyjlDFw/tqAAvRf76uF0/fd
 2aHiPbocKN2uTYvtIXn/NFwhUfHr5rmapnRSXPh9r27tY7YsfD
 RhooriRpwWXNOlCauZqYXD/3+BNlwq0IyvKRXK4IUhZD+pkudC
 dIT6hCVGRbND9EV7Ymbc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
> > The newly created omap_hwmod_reset.c is missing an
> > include of linux/errno.h in commit c02060d8 "ARM:
> > OMAP4+: AESS: enable internal auto-gating during
> > initial setup". It still works in omap2_defconfig,
> > but not in all other combinations.
> > 
> > Without this patch, building allmodconfig results in:
> > 
> > arch/arm/mach-omap2/omap_hwmod_reset.c: In function 'omap_hwmod_aess_preprogram':
> > arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: error: 'EINVAL' undeclared (first use in this function)
> > arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Paul Walmsley <paul@pwsan.com>
> > Cc: Sebastien Guiriec <s-guiriec@ti.com>
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Ok, applied on top of late/omap

	Arnd
