Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaGNKdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:33:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48319 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaGNKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:32:56 -0400
Message-ID: <53C3B1D5.6030705@linaro.org>
Date: Mon, 14 Jul 2014 11:32:53 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 0/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org> <1405327664-27439-1-git-send-email-srinivas.kandagatla@linaro.org> <53C3B138.2070006@ti.com>
In-Reply-To: <53C3B138.2070006@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/07/14 11:30, Kishon Vijay Abraham I wrote:
>
>
> On Monday 14 July 2014 02:17 PM, Srinivas Kandagatla wrote:
>> Hi Kishon,
>>
>> First patch in this series adds support to the APQ8064 SATA PHY.
>> Second patch updates the existing Kumar gala's device tree PHY bindings
>> with APQ8064 soc specific compatible.
>>
>> Eventhough there are two seperate drivers for both IPQ and APQ SOCs,
>> the bindings are exactly same, so I did not create new bindings document.
>
> Er.. create a separate binding.

Ok, no issues.
>>
>> Could you please pick these patches for v3.17.
>
> Sure. please rebase to linux-phy next and re-send.
I will do it.

thanks,
srini
>
> Thanks
> Kishon
>>
>> Changes since v2:
>> 	- added usleep_range in poll timeout as discussed
>> 		with Bartlomiej Zolnierkiewicz.
>> 	- Added missing pdev_set_drvdata spotted by
>> 		Bartlomiej Zolnierkiewicz
>>
>> Changes since v1:
>> 	- included DT bindings in the series.
>>
>> Thanks,
>> srini
>>
>> Srinivas Kandagatla (2):
>>    phy: qcom: Add driver for QCOM APQ8064 SATA PHY
>>    phy: qcom: Update APQ8064 PHY device tree bindings
>>
>>   Documentation/devicetree/bindings/phy/qcom-phy.txt |   3 +-
>>   drivers/phy/Kconfig                                |   7 +
>>   drivers/phy/Makefile                               |   1 +
>>   drivers/phy/phy-qcom-apq8064-sata.c                | 288 +++++++++++++++++++++
>>   4 files changed, 298 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
>>
