Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3ILKfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:35:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8611 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3ILKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:35:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Sep 2013 03:32:06 -0700
Message-ID: <1378982108.2475.3.camel@bilhuang-vm1>
Subject: Re: [PATCH 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
From: Bill Huang <bilhuang@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Thu, 12 Sep 2013 03:35:08 -0700
In-Reply-To: <20130912101459.GG30013@tbergstrom-lnx.Nvidia.com>
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
	 <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
	 <20130912101459.GG30013@tbergstrom-lnx.Nvidia.com>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 18:14 +0800, Peter De Schrijver wrote:
> On Wed, Sep 11, 2013 at 01:19:14PM +0200, Bill Huang wrote:
> 
> > +static inline int tegra_cpufreq_init(void)
> > +{
> > +       retrun EOPNOTSUPP;
> 
> This should be -EOPNOTSUPP at least. I think -EINVAL might be better.

Yeah thanks, I'll also fix the TYPO of return.
> 
> Cheers,
> 
> Peter.


