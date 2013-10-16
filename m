Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3JPOqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:46:23 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3598 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3JPOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:46:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Oct 2013 07:41:55 -0700
Date: Wed, 16 Oct 2013 17:46:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] clk: tegra30: replace enum by binding header
Message-ID: <20131016144618.GL5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <1381848794-11761-15-git-send-email-pdeschrijver@nvidia.com>
 <525D9A85.40102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525D9A85.40102@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:41:57PM +0200, Stephen Warren wrote:
> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> > As the clock IDs are now specified in a header file, we can use those
> > definitions instead of maintaining an internal enum.
> 
> Nit: The patch subject should say "clk: tegra:" not "clk: tegra20:" so
> that anyone looking at the tags in the subject has only one "tegra"
> value to look at, not a whole bunch of them.
> 
> Would it make sense to squash patches 15, 16, 18 together (and similar
> for Tegra30) to avoid some churn i.e. the fact that the entire body of
> tegra_periph_clk_list[] gets replaced twice?

You mean do all the changes for Tegra20 and Tegra30 in 1 patch per SoC?

Cheers,

Peter.
