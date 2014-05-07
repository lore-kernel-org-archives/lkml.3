Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaEGWVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:21:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56073 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGWVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140507153713.GA23775@amd.pavel.ucw.cz>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140416101243.GA6952@n2100.arm.linux.org.uk>
	<CADHgK6vyWU1HCueN=F5D0JxzknV==h-jOG9JmcXeOrH_RGV4JQ@mail.gmail.com>
	<CADHgK6v43=KSpe2FRG374nbHSMOt9hb+xEhO7z20vhEAQsx0tQ@mail.gmail.com>
	<CADHgK6tg=7JpYgc0LBmpQzJS-TjK5v_0FQeKRxuFNTqy=QSQzA@mail.gmail.com>
	<CADHgK6uCQT2iAfL+oQvwN7f65u4musKP-AX-E6j1i2OL6ZMJwA@mail.gmail.com>
	<20140507153713.GA23775@amd.pavel.ucw.cz>
Date: Wed, 7 May 2014 15:20:59 -0700
Message-ID: <CADHgK6tUDZeumk9VPpQ2fLubSE9686Tf==KdfcN+TY1ePryeAw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Pavel!

I believe it's missed 3.15, so will need to verify again for 3.16.

Sebastian
