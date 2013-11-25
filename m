Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3KYNmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:42:55 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11691 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3KYNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:42:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 05:40:31 -0800
Date: Mon, 25 Nov 2013 15:42:05 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Alex Courbot <acourbot@nvidia.com>, Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: add FUSE clock device
Message-ID: <20131125134205.GH26617@tbergstrom-lnx.Nvidia.com>
References: <1385001490-18927-1-git-send-email-acourbot@nvidia.com>
 <20131122134140.GE26617@tbergstrom-lnx.Nvidia.com>
 <528F8462.4010105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <528F8462.4010105@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:20:50PM +0100, Stephen Warren wrote:
> On 11/22/2013 06:41 AM, Peter De Schrijver wrote:
> > On Thu, Nov 21, 2013 at 03:38:10AM +0100, Alexandre Courbot wrote:
> >> This clock is needed to ensure the FUSE registers can be accessed
> >> without freezing the system.
> >>
> >> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > 
> > Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Aren't you taking this patch through the clock tree?

Will do.
