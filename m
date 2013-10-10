Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3JJIvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:51:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18330 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3JJIvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:51:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Oct 2013 01:47:27 -0700
Date: Thu, 10 Oct 2013 11:51:36 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/5] clk: tegra124: Add new peripheral clocks
Message-ID: <20131010085136.GP4233@tbergstrom-lnx.Nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
 <1380878014-22088-5-git-send-email-pdeschrijver@nvidia.com>
 <525487C7.6080103@wwwdotorg.org>
 <20131009081123.GB3973@tbergstrom-lnx.Nvidia.com>
 <52557D92.9050200@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52557D92.9050200@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 06:00:18PM +0200, Stephen Warren wrote:
> On 10/09/2013 02:11 AM, Peter De Schrijver wrote:
> > On Wed, Oct 09, 2013 at 12:31:35AM +0200, Stephen Warren wrote:
> >> On 10/04/2013 03:12 AM, Peter De Schrijver wrote:
> >>> Tegra124 introduces a number of new peripheral clocks. This patch adds those
> >>> to the common peripheral clock code.
> >>
> >> Don't you need to add AFC[0..5] in this patch and/or patch 5?
> > 
> > AFC[0..5] are reset only nodes afaik. Up to now, we haven't done that.
> > The goal is to include them once we move to the reset framework.
> 
> No, we've always added clock entries for all reset-only clocks into the
> clock driver. Since the port to the reset framework is not available
> yet, we need to continue to do this. Otherwise, we won't be able to
> upstream audio support.
> 

The only clock which required this up to now was 'cop' (avp). Which is not
in upstream.

Cheers,

Peter.
