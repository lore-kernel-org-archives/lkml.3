Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaGPIcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:32:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13452 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaGPIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:30:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jul 2014 01:23:31 -0700
Date: Wed, 16 Jul 2014 11:30:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Rhyland Klein <rklein@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "Mike Turquette" <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, "Alex Courbot" <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] clk: tegra: Add Tegra132 ccplex clocks
Message-ID: <20140716083042.GL23218@tbergstrom-lnx.Nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-7-git-send-email-pdeschrijver@nvidia.com>
 <53C5908C.5000009@nvidia.com> <53C591B1.4080302@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53C591B1.4080302@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:40:17PM +0200, Rhyland Klein wrote:
> On 7/15/2014 4:35 PM, Rhyland Klein wrote:
> > On 7/15/2014 11:24 AM, Peter De Schrijver wrote:
> >> Add support for the ccplex clocks in Tegra132.
> >>
> >> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> >> ---
> >>  drivers/clk/tegra/Makefile |    2 ++
> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> >> index f7dfb72..4231865 100644
> >> --- a/drivers/clk/tegra/Makefile
> >> +++ b/drivers/clk/tegra/Makefile
> >> @@ -15,3 +15,5 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
> >>  obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
> >>  obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
> >>  obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= clk-tegra124.o
> >> +obj-$(CONFIG_ARCH_TEGRA_132_SOC)	+= clk-tegra124.c
> >> +obj-$(CONFIG_ARCH_TEGRA_132_SOC)	+= clk-tegra132-ccplex.c
> 
> Also, shouldn't both these be .o not .c ?
> 
> -rhyland

Yes, obviously :)

Cheers,

Peter.
