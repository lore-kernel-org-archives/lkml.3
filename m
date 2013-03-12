Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3CLKM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:12:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3793 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3CLKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:12:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 03:06:26 -0700
Message-ID: <513EFF36.50107@nvidia.com>
Date: Tue, 12 Mar 2013 15:41:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH V2 0/5] ARM: DT: tegra114: Add DT entry for different
 controller
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <513E5771.9000408@wwwdotorg.org>
In-Reply-To: <513E5771.9000408@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013 03:45 AM, Stephen Warren wrote:
> On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
>> This patch series add DT entry for APB DMA, I2C, UART, KBC and SPI.
>>
>> This patch series is generated on top of CCF work for T114 done by Peter
>> and hence it should be applied on top of T114 CCF patches.
>>
>> Changes from V1:
>> - Add reeason why APBDMA is not compatible with older driver
>>    in description.
>> - Remove UARTB car id correction. Make the compatible with tegra114 and
>>    older chip.
>> - Add compatible for kbc as nvidia,tegra114-kbc and nvidia,tegra20-kbc.
>>
>> Laxman Dewangan (5):
>>    ARM: DT: tegra114: add APB DMA controller DT entry
>>    ARM: DT: tegra114: Add i2c controller DT entry
>>    ARM: DT: tegra114:add aliases and DMA requestor for serial controller
>>    ARM: DT: tegra114: add KBC controller DT entry
>>    ARM: DT: tegra114: Add spi controller DT entry
> What branch is this series based on? I tried to apply these for testing,
> but git am failed to apply it to Tegra's for-3.10/dt, and Tegra's
> for-next, and my local work branch, and next-20130307.
>
> Can you please rebase onto Tegra's for-3.10/dt. Thanks.

I created the patch as:
- linux next 20130307
- Then add all clock changes from Peter's
git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git

- Then I generated the DT entry on top of this which has clock reference.

In your 3.10/DT, there is no change for Peter's clock change and 
possibly this is the reason.


If I base my change on your 3.10/DT then:
- Do I need to add the clock entry for all modules also?


