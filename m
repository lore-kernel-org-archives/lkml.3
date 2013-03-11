Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3CKWPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:15:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40430 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3CKWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:15:16 -0400
Message-ID: <513E5771.9000408@wwwdotorg.org>
Date: Mon, 11 Mar 2013 16:15:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 0/5] ARM: DT: tegra114: Add DT entry for different
 controller
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
> This patch series add DT entry for APB DMA, I2C, UART, KBC and SPI.
> 
> This patch series is generated on top of CCF work for T114 done by Peter
> and hence it should be applied on top of T114 CCF patches.
> 
> Changes from V1:
> - Add reeason why APBDMA is not compatible with older driver
>   in description.
> - Remove UARTB car id correction. Make the compatible with tegra114 and
>   older chip.
> - Add compatible for kbc as nvidia,tegra114-kbc and nvidia,tegra20-kbc.
> 
> Laxman Dewangan (5):
>   ARM: DT: tegra114: add APB DMA controller DT entry
>   ARM: DT: tegra114: Add i2c controller DT entry
>   ARM: DT: tegra114:add aliases and DMA requestor for serial controller
>   ARM: DT: tegra114: add KBC controller DT entry
>   ARM: DT: tegra114: Add spi controller DT entry

What branch is this series based on? I tried to apply these for testing,
but git am failed to apply it to Tegra's for-3.10/dt, and Tegra's
for-next, and my local work branch, and next-20130307.

Can you please rebase onto Tegra's for-3.10/dt. Thanks.
