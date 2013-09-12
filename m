Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3ILKPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:15:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7595 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3ILKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:15:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Sep 2013 03:15:01 -0700
Date: Thu, 12 Sep 2013 13:14:59 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Bill Huang <bilhuang@nvidia.com>
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
Subject: Re: [PATCH 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
Message-ID: <20130912101459.GG30013@tbergstrom-lnx.Nvidia.com>
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
 <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:19:14PM +0200, Bill Huang wrote:

> +static inline int tegra_cpufreq_init(void)
> +{
> +       retrun EOPNOTSUPP;

This should be -EOPNOTSUPP at least. I think -EINVAL might be better.

Cheers,

Peter.
