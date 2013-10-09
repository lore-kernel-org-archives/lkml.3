Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3JIIL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:11:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1498 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3JIIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:11:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 Oct 2013 01:07:16 -0700
Date: Wed, 9 Oct 2013 11:11:23 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/5] clk: tegra124: Add new peripheral clocks
Message-ID: <20131009081123.GB3973@tbergstrom-lnx.Nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
 <1380878014-22088-5-git-send-email-pdeschrijver@nvidia.com>
 <525487C7.6080103@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525487C7.6080103@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 12:31:35AM +0200, Stephen Warren wrote:
> On 10/04/2013 03:12 AM, Peter De Schrijver wrote:
> > Tegra124 introduces a number of new peripheral clocks. This patch adds those
> > to the common peripheral clock code.
> 
> Don't you need to add AFC[0..5] in this patch and/or patch 5?

AFC[0..5] are reset only nodes afaik. Up to now, we haven't done that.
The goal is to include them once we move to the reset framework.

Cheers,

Peter.
