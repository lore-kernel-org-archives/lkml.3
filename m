Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3JNLnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:43:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65265 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756122Ab3JNLnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:43:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v2 0/2] cpufreq: exynos: Fixes for v3.12
Date: Mon, 14 Oct 2013 13:55:02 +0200
Message-ID: <1843510.1qhvR1ALD2@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131014075546.72e0dc61@amdc308.digital.local>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com> <2822925.9aRTDAMrLp@vostro.rjw.lan> <20131014075546.72e0dc61@amdc308.digital.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 14, 2013 07:55:46 AM Lukasz Majewski wrote:
> Hi Rafael,
> 
> > On Friday, October 11, 2013 01:22:57 PM Rafael J. Wysocki wrote:
> > > On Wednesday, October 09, 2013 02:08:41 PM Lukasz Majewski wrote:
> > > > Attached commits provide cpufreq regression fixes for Trats and
> > > > Trats2 Exynos4 boards.
> > > > Since v3.12 Exynos4 uses common clock framework for clock
> > > > manipulation. Those patches restore correct output for
> > > > cpuinfo_cur_freq [1] sysfs attribute.
> > > > Without them, the [1] provides default frequency (800 MHz) set at
> > > > driver initialization.
> > > > 
> > > > 
> > > > Lukasz Majewski (2):
> > > >   cpufreq: exynos4x12: Use the common clock framework to set APLL
> > > > clock rate
> > > >   cpufreq: exynos4210: Use the common clock framework to set APLL
> > > > clock rate
> > > > 
> > > >  drivers/cpufreq/exynos4210-cpufreq.c |   67
> > > > ++++-----------------------------
> > > > drivers/cpufreq/exynos4x12-cpufreq.c |   69
> > > > ++++------------------------------ 2 files changed, 16
> > > > insertions(+), 120 deletions(-)
> > > 
> > > Can you please resend [1/2], it got lost somewhere (at least I
> > > can't see it now)?
> > 
> > Scratch this, it's there in patchwork.
> > 
> 
> Rafael, do you need any more help with those fixes? 

Well, if I do, you'll know that. :-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
