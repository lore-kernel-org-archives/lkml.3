Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3BESoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:44:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47883 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3BESol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:44:41 -0500
Date: Tue, 5 Feb 2013 19:44:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205184438.GL4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Robin Randhawa <Robin.Randhawa@ARM.com>,
	Steve Bannister <Steve.Bannister@arm.com>,
	Liviu Dudau <Liviu.Dudau@arm.com>
References: <CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
 <20130204123221.GA22340@pd.tnic>
 <CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
 <20130204130403.GD13909@pd.tnic>
 <CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
 <20130204133648.GE13909@pd.tnic>
 <CAKohpokejWugM+wP5xcqp0F9AggLxuEf9Ox5fDViMxJh1c+kEw@mail.gmail.com>
 <80D6EFE2711DED4189C7C8F0430BFEA86D23D6A80E@BUNGLE.Emea.Arm.com>
 <20130205113950.GG4827@pd.tnic>
 <80D6EFE2711DED4189C7C8F0430BFEA86D23DFF1B1@BUNGLE.Emea.Arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80D6EFE2711DED4189C7C8F0430BFEA86D23DFF1B1@BUNGLE.Emea.Arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 06:38:07PM +0000, Charles Garcia-Tobin wrote:
> Later. Whatever you'd like to call it, but essentially a set of cpus,
> as linux understands them, that are logically related by the fact that
> you'd like to be able to use the same tuning policy and same governor
> across all of them.

Right, policy will be applied to the whole set, yes, but can you imagine
that per-core settings could also make sense at some point?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
