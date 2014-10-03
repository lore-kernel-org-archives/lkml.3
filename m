Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJCR3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:29:16 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43653 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJCR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:29:14 -0400
Message-ID: <542EDCDB.6040406@roeck-us.net>
Date: Fri, 03 Oct 2014 10:28:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com> <1412275071-6417-2-git-send-email-atull@opensource.altera.com> <20141003122736.GH26643@leverpostej>
In-Reply-To: <20141003122736.GH26643@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020201.542EDCE9.0168,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 4
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 05:27 AM, Mark Rutland wrote:
> On Thu, Oct 02, 2014 at 07:37:48PM +0100, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
>>
>> Add device tree bindings documentation for ltc2978.
>>
>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>> ---
>> v2: clean whitespace
>> ---
>>   .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
>>
>> diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
>> new file mode 100644
>> index 0000000..b2d9c4d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
>> @@ -0,0 +1,41 @@
>> +ltc2978
>> +
>> +Required properties:
>> + - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
>
> Could we please format this like:
>
> - compatible: should contain one of:
>    * "ltc2974"
>    * "ltc2977"
>    * "ltc2978"
>    * "ltc3880"
>    * "ltc3883"
>    * "ltm4676"
>
> Given the file name, are these all variants of ltc2978?
>
>> + - reg: I2C address
>> +
>> +Optional properties:
>> + Name of the optional regulator subnode must be "regulators".
>> +  - #address-cells must be 1.
>
> What's the single address cell used for?
>
I think this is required by the regulator bindings.
Other regulators use the same, though they don't typically
mention it in the properties list but only in the examples.

>> +  - #size-cells must be 0.
>> +
>> + For each regulator:
>> +  - reg: regulator number
>
> Which can be...?
>
> What does this correspond to in the HW?
>
Channel number or index. Pretty much the 0..7 from the name below.

>> +  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
>> +    valid range is:
>> +      ltc2977, ltc2978 : vout_en0 - vout_en7
>> +      ltc2974          : vout_en0 - vout_en3
>> +      ltc3880, ltm4676 : vout_en0 - vout_en1
>> +      ltc3883          : vout_en0 only
>
> In other bindings I believe I've seen the node name used for this.
>
Seems like per-device names are chosen for other regulators.
PMBus commonly uses the term "VOUT" for output voltages,
so vout[0-7] should be ok.

Which reminds me: We had earlier asked to drop the "_en" from the strings
as unnecessary.

> Mark, what's the preferred scheme for identifying regulators in a
> container node?
>
>> +  - regulator-name: arbitrary name for regulator
>
> Drop the 'aribtarary'. Either this should be the name of the regulator
> on the board, or it shouldn't be necessary.
>
Not sure if it even needs to be documented here. It is already documented
in Documentation/devicetree/bindings/regulator/regulator.txt.

> Mark.
>
>> +
>> +Example:
>> +ltc2978@5e {
>> +	compatible = "ltc2978";
>> +	reg = <0x5e>;
>> +	regulators {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		vdacp0_reg: regulator@0 {
>> +			reg = <0>;
>> +			regulator-compatible = "vout_en0";
>> +			regulator-name = "FPGA-2.5V";
>> +		};
>> +		vdacp2_reg: regulator@2 {
>> +			reg = <2>;
>> +			regulator-compatible = "vout_en2";
>> +			regulator-name = "FPGA-1.5V";
>> +		};
>> +	};
>> +};
>> --
>> 1.7.9.5
>>
>>
>

