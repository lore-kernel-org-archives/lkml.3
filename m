Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaFFP21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:28:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50860 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaFFP20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:28:26 -0400
Message-ID: <5391DE01.2080600@ti.com>
Date: Fri, 6 Jun 2014 10:28:01 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <tony@atomide.com>,
        <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: am43x-epos-evm: Add Missing cpsw-phy-sel for
 am43x-epos-evm
References: <1402035454-25676-1-git-send-email-george.cherian@ti.com> <53916556.10608@ti.com> <53918F75.1050000@ti.com>
In-Reply-To: <53918F75.1050000@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 04:52 AM, George Cherian wrote:
> On 6/6/2014 12:23 PM, Nishanth Menon wrote:
>> On 06/06/2014 01:17 AM, George Cherian wrote:
>>> AM437x EPOS evm use external clock for RMII interface.
>>> Enable the same in DT.
>>>
>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>> Reported-by: Nishanth Menon <nm@ti.com>
>>> ---
>>>   arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
>>> index 19f1f7e..90098f9 100644
>>> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
>>> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
>>> @@ -319,6 +319,10 @@
>>>   	phy-mode = "rmii";
>>>   };
>>>   
>>> +&phy_sel {
>>> +	rmii-clock-ext;
>>> +};
>>> +
>>>   &i2c0 {
>>>   	status = "okay";
>>>   	pinctrl-names = "default";
>>>
>> Where does this apply on?
>> With linux-next next-20140506 tag, and this patch applied, I get the
> Is'nt next-20140506 a month old.

Uggh.. yeah - 1AM+migraine is not a good combination to try to do
testing. :( Apologies on the noise


> I tried the patch on next-20140604.

Tested on next-20140606 - applies clean, builds and works :)

am43xx-epos:  Boot PASS: http://slexy.org/raw/s2fT6zs45y

Tested-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
