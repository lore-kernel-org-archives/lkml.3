Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3FEOSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:18:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17088 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3FEOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:18:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 07:17:27 -0700
Date: Wed, 5 Jun 2013 17:18:04 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Override bits for PLLM
Message-ID: <20130605141804.GQ3847@tbergstrom-lnx.Nvidia.com>
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 04:08:25PM +0200, Peter De Schrijver wrote:
> PLLM has override bits on Tegra30 and Tegra114. This patchset implements
> support for them for both Tegra30 and Tegra114.
> 

Depends on: 'PLL m,n,p init from SoC files'
