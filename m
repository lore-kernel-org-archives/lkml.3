Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaIQNmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:42:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17990 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbaIQNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:41:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Sep 2014 06:39:35 -0700
Date: Wed, 17 Sep 2014 16:41:55 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/8] ARM: tegra: Add PLL_M_UD and PLL_C_UD to
 tegra124-car binding header
Message-ID: <20140917134155.GJ26779@tbergstrom-lnx.Nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-4-git-send-email-mperttunen@nvidia.com>
 <53FB7564.7020304@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53FB7564.7020304@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:41:56PM +0200, Stephen Warren wrote:
> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> > Add these clocks to the binding header so that EMC timings that have
> > them as parent can refer to the clocks.
> 
> Peter, I assume this patch (and patch 4/8 too) will be needed by any EMC 
> driver, whether it's part of this series or Tomeu Vizoso's work. Can you 
> please review/ack those two patches for later reference. Thanks.

Looks ok to me. I will take them in tegra-clk-next
