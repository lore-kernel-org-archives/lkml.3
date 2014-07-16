Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbaGPLm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:42:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16082 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaGPLmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:42:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jul 2014 04:35:27 -0700
Message-ID: <53C6653A.7040107@nvidia.com>
Date: Wed, 16 Jul 2014 14:42:50 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com> <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <53C64553.9010704@gmail.com>
In-Reply-To: <53C64553.9010704@gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you comment. I decided to keep the format as is for now, 
however, to keep a consistent style between all binding files describing 
Tegra hardware.

Mikko

On 16/07/14 12:26, Varka Bhadram wrote:
> On 07/16/2014 02:24 PM, Mikko Perttunen wrote:
>> This patch adds device tree binding documentation for the SATA
>> controller found on NVIDIA Tegra SoCs.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>    .../devicetree/bindings/ata/tegra-sata.txt         | 30 ++++++++++++++++++++++
>>    1 file changed, 30 insertions(+)
>>    create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt
>>
>> diff --git a/Documentation/devicetree/bindings/ata/tegra-sata.txt b/Documentation/devicetree/bindings/ata/tegra-sata.txt
>> new file mode 100644
>> index 0000000..946f207
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ata/tegra-sata.txt
>> @@ -0,0 +1,30 @@
>> +Tegra124 SoC SATA AHCI controller
>> +
>> +Required properties :
>> +- compatible : "nvidia,tegra124-ahci".
>> +- reg : Should contain 2 entries:
>> +  - AHCI register set (SATA BAR5)
>> +  - SATA register set
>> +- interrupts : Defines the interrupt used by SATA
>> +- clocks : Must contain an entry for each entry in clock-names.
>> +  See ../clocks/clock-bindings.txt for details.
>> +- clock-names : Must include the following entries:
>> +  - sata
>> +  - sata-oob
>> +  - cml1
>> +  - pll_e
>
> It would be more readable if it like this...
>
> Required properties :
> - compatible	: "nvidia,tegra124-ahci".
> - reg		: Should contain 2 entries:
> 		  - AHCI register set (SATA BAR5)
> 		  - SATA register set
> - interrupts	: Defines the interrupt used by SATA
> - clocks	: Must contain an entry for each entry in clock-names.
> 		  See ../clocks/clock-bindings.txt for details.
> ....
>
>> +- resets : Must contain an entry for each entry in reset-names.
>> +  See ../reset/reset.txt for details.
>> +- reset-names : Must include the following entries:
>> +  - sata
>> +  - sata-oob
>> +  - sata-cold
>> +- phys : Must contain an entry for each entry in phy-names.
>> +  See ../phy/phy-bindings.txt for details.
>> +- phy-names : Must include the following entries:
>> +  - sata-phy : XUSB PADCTL SATA PHY
>> +- hvdd-supply : Defines the SATA HVDD regulator
>> +- vddio-supply : Defines the SATA VDDIO regulator
>> +- avdd-supply : Defines the SATA AVDD regulator
>> +- target-5v-supply : Defines the SATA 5V power regulator
>> +- target-12v-supply : Defines the SATA 12V power regulator
>
> Same....
>
>
