Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbaGPErD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:47:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58238 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbaGPErC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:47:02 -0400
Message-ID: <53C6039C.8000208@ti.com>
Date: Wed, 16 Jul 2014 10:16:20 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: Re: [RESEND PATCH 0/8] arm: dts: dra7: Add PCIe data and PCIe PHY
 data
References: <1405334543-25509-1-git-send-email-kishon@ti.com> <20140715071859.GL20068@atomide.com>
In-Reply-To: <20140715071859.GL20068@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 15 July 2014 12:48 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [140714 03:44]:
>> [1] is split into separate series in order for individual subsystem
>> Maintainers to pick up the patches. This series handles the PCIe
>> dt data for DRA7.
>>
>> This series has better commit logs than the previous one modified as
>> suggested by Tero.
>>
>> [1] -> https://lkml.org/lkml/2014/5/29/258
>>
>> Keerthy (2):
>>   ARM: dts: dra7xx-clocks: Add divider table to optfclk_pciephy_div
>>     clock
>>   ARM: dts: dra7xx-clocks: Change the parent of apll_pcie_in_clk_mux to
>>     dpll_pcie_ref_m2ldo_ck
>>
>> Kishon Vijay Abraham I (6):
>>   ARM: dts: dra7xx-clocks: Add missing 32KHz clocks used for PHY
>>   ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY
>>     instance
>>   ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY
>>     instance
>>   ARM: dts: dra7: Add dt data for PCIe PHY control module
>>   ARM: dts: dra7: Add dt data for PCIe PHY
>>   ARM: dts: dra7: Add dt data for PCIe controller
>>
>>  arch/arm/boot/dts/dra7.dtsi          |  127 ++++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/dra7xx-clocks.dtsi |   39 ++++++++++-
>>  2 files changed, 163 insertions(+), 3 deletions(-)
> 
> Applying this series into omap-for-v3.17/dt thanks.

Thanks :-)

-Kishon
> 
> Tony
> 
