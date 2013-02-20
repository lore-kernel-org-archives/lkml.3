Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932Ab3BTIKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:10:06 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35717 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934838Ab3BTIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:10:04 -0500
Date: Wed, 20 Feb 2013 08:09:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 10/35] mfd: ab8500-core: Rework MFD sub-device
 initialisation structures
Message-ID: <20130220080956.GA3368@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-11-git-send-email-lee.jones@linaro.org>
 <201302192207.31465.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302192207.31465.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Arnd Bergmann wrote:

> On Friday 15 February 2013, Lee Jones wrote:
> > +       {
> > +               .name = "ab8500-charger",
> > +               .of_compatible = "stericsson,ab8500-charger",
> > +               .num_resources = ARRAY_SIZE(ab8500_charger_resources),
> > +               .resources = ab8500_charger_resources,
> > +#ifndef CONFIG_OF
> > +               .platform_data = &ab8500_bm_data,
> > +               .pdata_size = sizeof(ab8500_bm_data),
> > +#endif
> > +       },
> 
> Is this #ifdef correct? I would have expected "#ifdef CONFIG_ATAGS"
> here.

No, it's not correct. See: 23a04f9f40f2b32ee593b768483105b1c776814d

I will fixup when the branched is rebased post-merge.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
