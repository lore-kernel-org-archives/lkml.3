Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3HLKud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:50:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3HLKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:50:27 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-2e-5208bdf2aa51
Date: Mon, 12 Aug 2013 12:50:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 5/8] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Message-id: <20130812125012.193608da@amdc308.digital.local>
In-reply-to: <CAKohponDoGhAdGOyK5f2Pxreq5-ZazxmkdZWfbU3OwtOMKbiHA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-6-git-send-email-l.majewski@samsung.com>
 <CAKohpokL57mXSQooX=4LZKtjMxJoXAB4uuzj13fgr3Gs7Wcf0A@mail.gmail.com>
 <20130726132120.5b9cf32f@amdc308.digital.local>
 <CAKohponvOXuHSS+-+m5PR9tPkAqkrYtjA3FJaNh9NJXrhQ9wmw@mail.gmail.com>
 <20130812122614.0d4d31a3@amdc308.digital.local>
 <CAKohponDoGhAdGOyK5f2Pxreq5-ZazxmkdZWfbU3OwtOMKbiHA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgO6nvRxBBgvmSVlsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRtcXnXHDaLz71HGC36F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBk/OoUL+rkqluw5xNrAOJu9i5GTQ0LARGLb4RXMELaYxIV769m6GLk4hAQWMUrsebECymln
	kljS3ccIUsUioCpxbPl+sG42AT2Jz3efMnUxcnCICGhJvLyZClLPLPCXWaLvUQMbSI2wQLxE
	Y9MBMJtXwFpi1Zm9rCA2p0CwxOW+CywQC34wS1y5eghsKL+ApET7vx9QJ9lJnPu0gR2iWVDi
	x+R7LCA2M9CyzduaWCFseYnNa94yT2AUnIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECI6kZ9I7GFc1WBxiFOBgVOLh9fjCHiTEmlhWXJl7iFGCg1lJhFdtHkeQEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZtV7/WX/jWyK/Q
	Udievz6cc9uBqOMKDVWh95lWvPZOn7D2yOGVdyYrMM89uaYi55ATA0+YafXG1FXnj7eUTTbr
	+85+skPaUZV715MPX7+ImpXJ/g9eeGJFT05eVwDHnVQbpV1p2rVNe09PWn5t0/KOi9qs873N
	87P1PxRMNGDsspzm9YjXTF2JpTgj0VCLuag4EQBNg4UsoAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 15:58:12 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 12 August 2013 15:56, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > 1. at ./drivers/cpufreq/Kconfig:
> >
> > +config CPU_FREQ_BOOST_SW
> > +       bool
> > +       depends on THERMAL
> >
> > 2. at ./drivers/cpufreq/Kconfig.arm:
> >
> > +config ARM_EXYNOS_CPU_FREQ_BOOST_SW
> > +       bool "EXYNOS Frequency Overclocking - Software"
> > +       depends on ARM_EXYNOS_CPUFREQ
> > +       select CPU_FREQ_BOOST_SW
> > +       select EXYNOS_THERMAL
> > +       default n
	    ^^^^^^^^^^^^^^^^ I will also remove this line.

> > +       help
> > +         This driver supports software managed overclocking
> > (BOOST).
> > +         It allows usage of special frequencies for Samsung Exynos
> > +         processors if thermal conditions are appropriate.
> > +
> > +         It reguires, for safe operation, thermal framework with
> >   properly
> > +         defined trip points.
> > +
> > +         If in doubt, say N.
> > +
> >
> > Shall I split this patch to two (1. and 2.) or leave it as a single
> > one?
> 
> Looks fine.. Keep it in a single patch.

Ok. 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
