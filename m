Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3IQN0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:26:42 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:47241 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3IQN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:26:40 -0400
Message-ID: <52385889.4090200@baylibre.com>
Date: Tue, 17 Sep 2013 15:26:33 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Koen Kooi <koen@dominion.thruhere.net>, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/4] ARM: dts: am335x-boneblack: add eMMC DT entry
References: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net> <1379010935-25943-3-git-send-email-koen@dominion.thruhere.net> <20130913152705.GN7189@atomide.com>
In-Reply-To: <20130913152705.GN7189@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 13/09/2013 17:27, Tony Lindgren wrote:
> * Koen Kooi <koen@dominion.thruhere.net> [130912 11:43]:
>> The pinmux is specified in am335x-bone-common.dtsi to be reused by the eMMC cape.
>>
>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>> ---
>>   arch/arm/boot/dts/am335x-bone-common.dtsi | 22 ++++++++++++++++++++++
>>   arch/arm/boot/dts/am335x-boneblack.dts    | 14 ++++++++++++++
>>   2 files changed, 36 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> index 0d95d54..bc8d1a2 100644
>> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
>> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> @@ -113,6 +113,21 @@
>>   				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
>>   			>;
>>   		};
>> +
>> +		emmc_pins: pinmux_emmc_pins {
>> +			pinctrl-single,pins = <
>> +				0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk, INPUT_PULLUP | MODE2 */
>> +				0x84 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_csn2.mmc1_cmd, INPUT_PULLUP | MODE2 */
>> +				0x00 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad0.mmc1_dat0, INPUT_PULLUP | MODE1 */
>> +				0x04 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad1.mmc1_dat1, INPUT_PULLUP | MODE1 */
>> +				0x08 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad2.mmc1_dat2, INPUT_PULLUP | MODE1 */
>> +				0x0c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad3.mmc1_dat3, INPUT_PULLUP | MODE1 */
>> +				0x10 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad4.mmc1_dat4, INPUT_PULLUP | MODE1 */
>> +				0x14 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad5.mmc1_dat5, INPUT_PULLUP | MODE1 */
>> +				0x18 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad6.mmc1_dat6, INPUT_PULLUP | MODE1 */
>> +				0x1c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad7.mmc1_dat7, INPUT_PULLUP | MODE1 */
>> +			>;
>> +		};
>>   	};
>>
>>   	ocp {
>
> Here you can now use just the defines to make it a bit shorter:
>
> 0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk */

Considering that Koen has just disappeared for a 3 weeks honeymoon, I'll 
fix the patch. GIT does complain about various trailing spaces and end 
of file issue for this patch as well :-(

Regards,
Benoit

