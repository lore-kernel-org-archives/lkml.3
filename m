Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3JUT5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:57:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34853 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3JUT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:57:50 -0400
Message-ID: <52658736.6050707@wwwdotorg.org>
Date: Mon, 21 Oct 2013 20:57:42 +0100
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>, mturquette@linaro.org
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for Tegra clock rework and Tegra124 clock support
References: <20131021135638.GA10943@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131021135638.GA10943@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 02:56 PM, Peter De Schrijver wrote:
> Hi Mike,
> 
> This pull request contains both the tegra clock rework patches
> ([PATCH v6 00/15] Introduce common infra for tegra clocks)
> and the patches to support Tegra124 ([PATCH v4 0/7] Tegra124 clock support)
> 
> The following changes since commit d031acfc0b8376209e5b429513766e7028e40e1d:
> 
>   clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d (2013-10-16 19:49:25 +0300)
> 
> are available in the git repository at:
>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-tegra124-0
> 
> Joseph Lo (2):
>       clk: tegra124: add wait_for_reset and disable_clock for tegra_cpu_car_ops
>       clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Acked-by: Stephen Warren <swarren@nvidia.com>

