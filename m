Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaISNMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:12:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16813 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbaISNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:12:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Sep 2014 06:13:01 -0700
Date: Fri, 19 Sep 2014 16:12:45 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 0/3] Introduce of_match_machine() helper
Message-ID: <20140919131245.GQ26779@tbergstrom-lnx.Nvidia.com>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
 <53FB7642.1000808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53FB7642.1000808@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:45:38PM +0200, Stephen Warren wrote:
> On 08/07/2014 05:01 PM, Tuomas Tynkkynen wrote:
> > Some mach-specific drivers that don't require their own node in the device tree
> > (for example drivers/soc/*, cpufreq, cpuidle etc.) want to match on the device
> > tree root compatible property instead. Instead of open-coding (and forgetting
> > to call of_node_put on the root node) everywhere, add a helper to the OF core.
> 
> Tuomas, I assume there will be a new version of this series to address 
> the review comments? For now, I'm not intending on applying this.

Given that Tuomas's internship ended, I'm willing to push this patch set
forward, if there is interest. So are people still interested in this idea
or should we drop it?

Thanks,

Peter.
