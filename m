Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3A3D5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:57:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5805 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3A3D46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:56:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 19:56:35 -0800
Message-ID: <5108998B.4040809@nvidia.com>
Date: Wed, 30 Jan 2013 09:24:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] ARM: DT: tegra114: add APB DMA controller DT entry
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com> <1359464183-6255-4-git-send-email-ldewangan@nvidia.com> <510809FC.2080806@wwwdotorg.org>
In-Reply-To: <510809FC.2080806@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013 11:12 PM, Stephen Warren wrote:
> On 01/29/2013 05:56 AM, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
>> APB DMA controllers and make it compatible with "nvidia,tegra114-apbdma".
> The APB DMA controller node needs a clocks property. The same goes for
> I2C and KBC. I'd like to avoid merging those 3 patches until the
> Tegra114 clock patches are present, since the nodes won't be useful
> until then anyway. I expect the clock patches will be merged in 3.10.
>

I think clock patches can be posted on top of this as Peter is working. 
Although, the driver will fail in clk_get() but still I think this can 
be apply to populate the dts file with controller specific information.

