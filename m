Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaEVIgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:36:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8752 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaEVIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:36:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 22 May 2014 01:30:26 -0700
Date: Thu, 22 May 2014 11:36:32 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for Tegra clock fixes for 3.16 with HDA clocks
Message-ID: <20140522083632.GG15168@tbergstrom-lnx.Nvidia.com>
References: <20140521112516.GA22484@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140521112516.GA22484@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 01:25:16PM +0200, Peter De Schrijver wrote:
> Hi Mike,
> 
> A number of fixes which are needed by the upcoming XHCI and SATA drivers and
> the HDA audio driver.
> 
> Thanks,
> 
> Peter.
> 
> The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:
> 
>   Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)
> 
> are available in the git repository at:
>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-v3.16-1

This is the correct pull request if I confused you :)

Thanks,

Peter.
