Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3JCJQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:16:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4682 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JCJQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:16:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Oct 2013 02:12:43 -0700
Date: Thu, 3 Oct 2013 12:16:36 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] Introduce common infra for tegra clocks
Message-ID: <20131003091636.GJ3973@tbergstrom-lnx.Nvidia.com>
References: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
 <524B08BD.2020902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <524B08BD.2020902@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 07:39:09PM +0200, Stephen Warren wrote:
> On 09/23/2013 08:24 AM, Peter De Schrijver wrote:
> > This patchset introduces common infrastructure for clocks which exist in
> > several Tegra SoCs. We also move Tegra114 to this new infrastructure.
> > Tegra20 and Tegra30 will be moved later in separate patchsets.
> > 
> > Changes since v1:
> > + move common clks allocation to patch 2
> > + adapt also Tegra20 and Tegra30 to the changes in patch 2
> > 
> > Boottested on dalmore, beaverboard and seaboard.
> 
> What commit is this series based on? I applied the two pre-requisites:
> 

9f186fbe58c749e2d4c0b334818705aa622fc76b Add linux-next specific files for 20130822

Cheers,

Peter.
