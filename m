Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaDWAiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:38:06 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52394 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaDWAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <CADHgK6v43=KSpe2FRG374nbHSMOt9hb+xEhO7z20vhEAQsx0tQ@mail.gmail.com>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140416101243.GA6952@n2100.arm.linux.org.uk>
	<CADHgK6vyWU1HCueN=F5D0JxzknV==h-jOG9JmcXeOrH_RGV4JQ@mail.gmail.com>
	<CADHgK6v43=KSpe2FRG374nbHSMOt9hb+xEhO7z20vhEAQsx0tQ@mail.gmail.com>
Date: Tue, 22 Apr 2014 17:38:01 -0700
Message-ID: <CADHgK6tg=7JpYgc0LBmpQzJS-TjK5v_0FQeKRxuFNTqy=QSQzA@mail.gmail.com>
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

Sorry for the delay.

I've merged the omap changes onto 3.15-rc2 and tested and it looks
like everything is working (so far 50 loops into/out of hibernation).

Thanks!

Sebastian
