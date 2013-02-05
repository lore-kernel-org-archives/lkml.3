Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3BELcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:32:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46244 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3BELcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:32:45 -0500
Date: Tue, 5 Feb 2013 12:32:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205113242.GF4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
	Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
References: <20130204165057.GH13909@pd.tnic>
 <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
 <20130205091532.GA4827@pd.tnic>
 <CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
 <20130205102721.GB4827@pd.tnic>
 <CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
 <20130205110407.GC4827@pd.tnic>
 <CAKohponiiVO_P2EDDTUHeoo7j3FG-ELtP8oLwfdEQ3HkgOS77g@mail.gmail.com>
 <20130205111918.GD4827@pd.tnic>
 <CAKohpomUsDr0YJmOxjymcAAJnfOxKfzxGL4iHuif1qCAvy0OYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpomUsDr0YJmOxjymcAAJnfOxKfzxGL4iHuif1qCAvy0OYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:56:03PM +0530, Viresh Kumar wrote:
> Just some kind of indication from platform driver is required about
> how/where it wants its governor directory to be present.

The indication is this:

config CPUFREQ_PLATFORM_DRIVER_X
        ...
        select CPUFREQ_MULTIPLE_POLICIES

You really need to slow down and really look at what I'm proposing.

> And the variable suits more here.

And this variable means nothing on other systems so why add it in the
first place?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
