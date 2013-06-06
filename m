Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3FFPVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab3FFPVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:21:16 -0400
Date: Thu, 6 Jun 2013 11:21:04 -0400
From: Dave Jones <davej@redhat.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at
 Kconfig
Message-ID: <20130606152104.GA11015@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lukasz Majewski <l.majewski@samsung.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocky" <rjw@sisk.pl>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jonghwa Lee <jonghwa3.lee@samsung.com>,
	Myungjoo Ham <myungjoo.ham@samsung.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Lukasz Majewski <l.majewski@majess.pl>,
	Andre Przywara <andre.przywara@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
 <20130606144910.GA1194@redhat.com>
 <20130606171431.41d63591@amdc308.digital.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606171431.41d63591@amdc308.digital.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 05:14:31PM +0200, Lukasz Majewski wrote:
 > Hi Dave,
 > 
 > > On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:
 > > 
 > >  > +config CPU_FREQ_BOOST
 > >  > +	bool "CPU frequency boost support"
 > >  > +	help
 > >  > +	  Switch to enable support for frequency boost
 > >  > +
 > >  > +	  If in doubt, say N.
 > >  > +
 > > 
 > > This help text is devoid of any useful information.
 > > 
 > > On what platforms ? What's the upside/downside ? Why is it an option ?
 > 
 > I shall be more verbose here.
 > 
 > The boost option is supposed to provide one solution to control
 > software based (like is is done with Samsung Exynos4 SoC) and hardware
 > based (like Intel's Turbo Boost feature) boost.
 > 
 > Support for Intel's boost is already in mainline. Therefore I aimed to
 > extend cpufreq to also manage software based solutions (e.g. Exynos).

Given CPUFREQ is available on more platforms than X86/ARM, this option
could also use a depends.

	Dave

