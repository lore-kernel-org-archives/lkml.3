Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3JJLAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:00:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5048 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3JJLAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:00:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Oct 2013 04:00:38 -0700
Date: Thu, 10 Oct 2013 14:00:32 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "Paul Walmsley" <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] clk: tegra: Add periph regs bank X
Message-ID: <20131010110032.GR4233@tbergstrom-lnx.Nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
 <1380878014-22088-3-git-send-email-pdeschrijver@nvidia.com>
 <20131010104306.GB6735@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131010104306.GB6735@ulmo.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:43:07PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Fri, Oct 04, 2013 at 12:12:41PM +0300, Peter De Schrijver wrote:
> > Tegra124 has an extra bank of peripheral clock registers. Add it to the
> > generic peripheral clock code.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  drivers/clk/tegra/clk.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> > index c8c84ce..0240dc3 100644
> > --- a/drivers/clk/tegra/clk.c
> > +++ b/drivers/clk/tegra/clk.c
> > @@ -57,6 +57,8 @@
> >  #define RST_DEVICES_CLR_V		0x434
> >  #define RST_DEVICES_SET_W		0x438
> >  #define RST_DEVICES_CLR_W		0x43c
> > +#define RST_DEVICES_SET_X		0x290
> > +#define RST_DEVICES_CLR_X		0x294
> 
> Perhaps sort these numerically rather than alphabetically? Also I don't

Why? I think alphabetically makes more sense or possibly per bank.

> see where the CLK_OUT_ENB_X, CLK_OUT_ENB_{SET,CLR}_X or RST_DEVICES_X
> registers are defined. Perhaps they were part of some other patch or a
> series that this depends on?
> 

Cheers,

Peter.
