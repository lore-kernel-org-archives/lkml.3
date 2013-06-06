Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3FFOt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3FFOtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:49:25 -0400
Date: Thu, 6 Jun 2013 10:49:10 -0400
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
Message-ID: <20130606144910.GA1194@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:

 > +config CPU_FREQ_BOOST
 > +	bool "CPU frequency boost support"
 > +	help
 > +	  Switch to enable support for frequency boost
 > +
 > +	  If in doubt, say N.
 > +

This help text is devoid of any useful information.

On what platforms ? What's the upside/downside ? Why is it an option ?

	Dave

