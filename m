Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3JWIqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:46:37 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16987 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3JWIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:46:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 23 Oct 2013 01:41:52 -0700
Date: Wed, 23 Oct 2013 11:46:31 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for Tegra clock rework and Tegra124 clock support
Message-ID: <20131023084631.GG22111@tbergstrom-lnx.Nvidia.com>
References: <20131021135638.GA10943@tbergstrom-lnx.Nvidia.com>
 <20131022101904.7554.73999@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131022101904.7554.73999@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 12:19:04PM +0200, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-10-21 06:56:38)
> > Hi Mike,
> > 
> > This pull request contains both the tegra clock rework patches
> > ([PATCH v6 00/15] Introduce common infra for tegra clocks)
> > and the patches to support Tegra124 ([PATCH v4 0/7] Tegra124 clock support)
> > 
> > The following changes since commit d031acfc0b8376209e5b429513766e7028e40e1d:
> > 
> >   clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d (2013-10-16 19:49:25 +0300)
> > 
> > are available in the git repository at:
> >   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-tegra124-0
> 
> Thanks for the pull request Peter. I've taken into clk-next. Next time
> can you generate a signed tag? Due to the increased volume of ccf

Ok :) let's sign some keys next week then :)

Cheers,

Peter.
