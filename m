Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaESIpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:45:23 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14656 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:45:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 01:39:35 -0700
Date: Mon, 19 May 2014 11:45:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Fix wrong value written to PLLE_AUX
Message-ID: <20140519084518.GP15168@tbergstrom-lnx.Nvidia.com>
References: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com>
 <20140516143110.GA28338@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140516143110.GA28338@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:31:11PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Fri, May 16, 2014 at 04:50:20PM +0300, Tuomas Tynkkynen wrote:
> > The value written to PLLE_AUX was incorrect due to a wrong variable
> > being used.
> > 
> > Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> > Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
> > ---
> >   This fix is required for the (upcoming) SATA support.
> >  drivers/clk/tegra/clk-pll.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> Tested-by: Thierry Reding <treding@nvidia.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> 
> Mike, Peter, it might be good to have this go into 3.16 as a
> prerequisite for the upcoming SATA driver (which presumably won't be
> ready until 3.17, but in that case it would be good to have this
> prerequisite merged already).

Yes... We should also take Andrew's fixes. I will prepare a pull request for 3.16.

Cheers,

Peter.
