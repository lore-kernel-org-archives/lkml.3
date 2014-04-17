Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaDQUiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:38:15 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46589 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaDQUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:38:04 -0400
MIME-Version: 1.0
In-Reply-To: <CADHgK6vyWU1HCueN=F5D0JxzknV==h-jOG9JmcXeOrH_RGV4JQ@mail.gmail.com>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140416101243.GA6952@n2100.arm.linux.org.uk>
	<CADHgK6vyWU1HCueN=F5D0JxzknV==h-jOG9JmcXeOrH_RGV4JQ@mail.gmail.com>
Date: Thu, 17 Apr 2014 13:38:03 -0700
Message-ID: <CADHgK6v43=KSpe2FRG374nbHSMOt9hb+xEhO7z20vhEAQsx0tQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jiang Liu <liuj97@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

It seems to work fine with your virt_to_phys on the 3.13 + OMAP
patches kernel, and I checked on the 3.15-rc1 kernel + hibernation and
it compiled and ran fine.  I tried a couple of hibernations on this
version as well and they worked (aside from the crash in kernel_halt
we're discussing separately).  I believe this just works by chance
though because the omap platform has no real hibernation support
there.

I'll try now to merge up the omap patches to 3.15-rc1.

Thanks,

Sebastian
