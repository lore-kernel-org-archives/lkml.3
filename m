Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaA2M05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:26:57 -0500
Received: from www.humilis.net ([80.100.93.5]:49344 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaA2M0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:26:55 -0500
Date: Wed, 29 Jan 2014 13:26:51 +0100
From: Sander <sander@humilis.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
Message-ID: <20140129122651.GB31980@panda>
Reply-To: sander@humilis.net
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
 <20140108143529.GB14122@mudshark.cambridge.arm.com>
 <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
 <20140108192028.GM27432@n2100.arm.linux.org.uk>
 <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
 <alpine.LFD.2.10.1401081600370.1851@knanqh.ubzr>
 <CAD=FV=XqoSGpQ_Yrjj4hvV_0FSMfQGcGEsKkL1Stnm9m5s2Xvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XqoSGpQ_Yrjj4hvV_0FSMfQGcGEsKkL1Stnm9m5s2Xvw@mail.gmail.com>
X-Uptime: 10:23:38 up 50 days, 13:37, 29 users,  load average: 2.00, 2.11,
 2.45
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote (ao):
> On Wed, Jan 8, 2014 at 1:08 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Wed, 8 Jan 2014, Doug Anderson wrote:
> >> * If Joe Upstream wants to run an upstream kernel on some type of
> >> exynos5250 product (Samsung ARM Chromebook, HP Chromebook 11, Nexus 10
> >> are the ones I know of) then he will deal with the small number of
> >> crashes or figure out a solution.
> >
> > If Joe Upstream wants to run an upstream kernel, doesn't he have to
> > unscrew his write protect switch first, at which point the RO firmware
> > can be updated as well?
> 
> Actually, no.  You can move your device into dev mode and run any
> kernel you want.  You'll get an annoying "you're in dev mode" screen
> at every bootup, but otherwise it works just fine.
> 
> Going into dev mode requires some special keystrokes at bootup and a
> wipe of your hard disk but no screwdrivers.

And there is http://www.arndaleboard.org/ where you just put an upstream
kernel on sd and boot.

	Sander
