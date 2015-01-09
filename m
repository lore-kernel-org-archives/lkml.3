Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbbAIVIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:08:55 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:44345 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbAIVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:08:54 -0500
Date: Fri, 9 Jan 2015 21:08:53 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Allen Martin <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: tegra: Add support for the Tegra132 CAR IP
 block
In-Reply-To: <54B0417B.6030409@wwwdotorg.org>
Message-ID: <alpine.DEB.2.02.1501092106070.28771@utopia.booyaka.com>
References: <20141216203813.22980.2301.stgit@chromeos-P9X79> <20141216203829.22980.64446.stgit@chromeos-P9X79> <20150109111954.GB16465@ulmo> <alpine.DEB.2.02.1501092030180.28771@utopia.booyaka.com> <54B0417B.6030409@wwwdotorg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015, Stephen Warren wrote:

> On 01/09/2015 01:52 PM, Paul Walmsley wrote:
> > Hi Thierry
> > 
> > On Fri, 9 Jan 2015, Thierry Reding wrote:
> > 
> > > On Tue, Dec 16, 2014 at 12:38:29PM -0800, Paul Walmsley wrote:
> > > > 
> > > > This patch is based on several patches from others:
> > > > 
> > > > 1. a  patch from Peter De Schrijver:
> > > > 
> > > > http://lkml.iu.edu/hypermail/linux/kernel/1407.1/06094.html
> > > > 
> > > > 2. a patch from Bill Huang ("clk: tegra: enable cclk_g at boot on
> > > > Tegra132"), and
> > > > 
> > > > 3. a patch from Allen Martin ("clk: Enable tegra clock driver for
> > > > tegra132").
> > > 
> > > Doesn't this technically require Signed-off-bys from each of the above,
> > > then?
> > 
> > I don't think so.  Documentation/SubmittingPatches states:
> 
> It's certainly been deemed acceptable in the past, if admittedly not optimal,
> for the person who is the "exit point" of an organization/company for the
> patch to be the only person to sign it off. The reason being they're vouching
> that the Certificate of Origin applies to all the company-sponsored work
> internal to the organization.

I'm not even sure that applies to this patch.  If I were passing along a 
verbatim copy of someone else's patch, or a copy with minor modifications, 
then it definitely be appropriate and expected to pass along their 
Signed-off-by:.  But this patch is original work; it's not a verbatim copy 
of any of the patches that I mention above (which are all publicly 
available, incidentally).


- Paul
