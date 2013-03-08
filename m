Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374Ab3CHSFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:05:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17696 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331Ab3CHSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:05:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 10:05:52 -0800
Message-ID: <513A281B.9010702@nvidia.com>
Date: Fri, 8 Mar 2013 23:34:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 3/5] ARM: DT: tegra114:add aliases and DMA requestor for
 serial controller
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com> <1362750782-15174-4-git-send-email-ldewangan@nvidia.com> <513A25E4.8040504@wwwdotorg.org>
In-Reply-To: <513A25E4.8040504@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 11:24 PM, Stephen Warren wrote:
> On 03/08/2013 06:53 AM, Laxman Dewangan wrote:
>> Add APB DMA requestor and serial aliases for serial controller.
>> There will be two serial driver i.e. 8250 based simple serial driver
>> and APB DMA based serial driver for higher baudrate and performace.
>>
>> The simple serial driver get enabled with compatible nvidia,tegra20-uart
>> and APB DMA based driver will get enabled with compatible
>> nvidia,tegra30-hsuart.
>>
>> Also Fix the clock id for the UARTB.
> If you feel like saying "also", that should probably be a separate patch!

I will remove "also ..." as I did not see the Documetation part. I think 
it is correct as per Dcoument.

>> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
>> +	/*
>> +	 * There are two serial driver i.e. 8250 based simple serial
>> +	 * driver and APB DMA based serial driver for higher baudrate
>> +	 * and performace. To enable the 8250 based driver, the compatible
>> +	 * is "nvidia,tegra30-uart", "nvidia,tegra20-uart" and to enable
>> +	 * the APB DMA based serial driver, the comptible is
>> +	 * "nvidia,tegra30-hsuart", "nvidia,tegra20-hsuart".
>> +	 */
> Any references to Tegra30 there should be changed to Tegra114 I think.

Ok, there is not change on tegra30 and Tegra114, also we have not added 
the tegra114 compatible in driver file.

