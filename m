Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3ILCYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:24:39 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9807 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3ILCYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:24:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Sep 2013 19:03:30 -0700
Message-ID: <1378951402.2475.2.camel@bilhuang-vm1>
Subject: Re: [PATCH 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Wed, 11 Sep 2013 19:03:22 -0700
In-Reply-To: <5230C596.7010000@wwwdotorg.org>
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
	 <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
	 <5230C596.7010000@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 03:33 +0800, Stephen Warren wrote:
> On 09/11/2013 05:19 AM, Bill Huang wrote:
> > diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
> 
> > +static struct cpufreq_frequency_table freq_table[] = {
> > +	{ .frequency = 216000 },
> > +	{ .frequency = 312000 },
> > +	{ .frequency = 456000 },
> > +	{ .frequency = 608000 },
> > +	{ .frequency = 760000 },
> > +	{ .frequency = 816000 },
> > +	{ .frequency = 912000 },
> > +	{ .frequency = 1000000 },
> > +	{ .frequency = CPUFREQ_TABLE_END },
> > +};
> 
> Should/can we query that list from the clock driver?
> 
It's not easy to query that list from clock driver so I'll leave it as
it was. I'll take all the other comments, thanks.

