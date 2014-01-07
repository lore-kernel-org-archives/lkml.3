Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaAGMvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:51:44 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1142 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaAGMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:51:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Jan 2014 04:51:59 -0800
Date: Tue, 7 Jan 2014 14:51:22 +0200
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
Subject: Re: pull request for some small fixes
Message-ID: <20140107125122.GC26588@tbergstrom-lnx.Nvidia.com>
References: <20131223162705.GE3378@tbergstrom-lnx.Nvidia.com>
 <20140106054322.26907.37296@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140106054322.26907.37296@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 06:43:22AM +0100, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-12-23 08:27:05)
> > The following changes since commit 62ce7cd62f534023224912dc9b909963f26a38da:
> > 
> >   clk: tegra: fix __clk_lookup() return value checks (2013-11-28 15:09:22 +0200)
> > 
> > are available in the git repository at:
> >   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git clk-tegra-next-1
> 
> Hi Peter,
> 
> Do you intend for this to go as fixes for 3.13-rc8? The fixes are based

Yes.

> off of a commit from my clk-next branch.
> 
Do you want me to rebase them on 3.13-rc7?

Cheers,

Peter.
