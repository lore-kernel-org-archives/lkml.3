Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaI3IRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:17:05 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:39759 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaI3IRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:17:01 -0400
Message-ID: <542A66F7.2000607@linaro.org>
Date: Tue, 30 Sep 2014 09:16:55 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: DT: apq8064: Add usb host support.
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982100-7964-1-git-send-email-srinivas.kandagatla@linaro.org> <20140930051728.GI28481@sonymobile.com>
In-Reply-To: <20140930051728.GI28481@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/09/14 06:17, Bjorn Andersson wrote:
> On Mon 29 Sep 02:15 PDT 2014, Srinivas Kandagatla wrote:
>
>> This patch adds device tree nodes to support two usb hosts on APQ8064
>> SOC.

>> +				compatible	= "qcom,rpm-pm8921-smps";
>> +				reg		= <QCOM_RPM_PM8921_SMPS3>;
>> +
>> +				regulator-min-microvolt = <1000000>;
>> +				regulator-max-microvolt = <1400000>;
>> +				qcom,boot-load 		= <49360>;
>
> As it was unclear how to handle load in the driver I dropped boot-load for now.
> Please leave it out until someone have added it to the driver.

Ok, will drop this in next version.

>
>> +				regulator-always-on;
>
> Why are all these "always-on"?
I added this for a regulator which was shared between hdmi and sata, I 
think for other regualtors this was just a copy paste error. I will 
recheck it once again and send a new version.

thanks,
srini
>
>> +			};
>> +
>> +		};
>> +
>>
>>   		/* Temporary fixed regulator */
>> --
>> 1.9.1
>>
