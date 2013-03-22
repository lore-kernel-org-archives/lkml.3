Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3CVMJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:09:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13231 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3CVMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:09:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 05:09:19 -0700
Date: Fri, 22 Mar 2013 14:09:20 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Don't enable PLLs during early boot
Message-ID: <20130322120920.GW18519@tbergstrom-lnx.Nvidia.com>
References: <1363953762-29783-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363953762-29783-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 01:02:33PM +0100, Peter De Schrijver wrote:
> The PLL code relies on udelay() which is not available when CCF is
> initialized. Hence we can't enable any PLL during this phase.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 

Sorry for accidently reposting this.

Cheers,

Peter.
