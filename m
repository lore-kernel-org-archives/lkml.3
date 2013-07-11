Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3GKKom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:44:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44233 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3GKKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:44:41 -0400
Message-ID: <51DE8C81.9090009@ti.com>
Date: Thu, 11 Jul 2013 16:14:17 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: J Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <broonie@kernel.org>,
        <ldewangan@nvidia.com>, <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
References: <1371726289-10042-1-git-send-email-j-keerthy@ti.com> <20130711104327.GE25601@gmail.com>
In-Reply-To: <20130711104327.GE25601@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 July 2013 04:13 PM, Lee Jones wrote:
> On Thu, 20 Jun 2013, J Keerthy wrote:
>
>> Add TPS659038 documentation under Palmas.
>>
>> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
>> ---
>>   Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
>> index 7bcd59c..89cb773 100644
>> --- a/Documentation/devicetree/bindings/mfd/palmas.txt
>> +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
>> @@ -5,6 +5,7 @@ twl6035 (palmas)
>>   twl6037 (palmas)
>>   tps65913 (palmas)
>>   tps65914 (palmas)
>> +tps659038
>>   
>>   Required properties:
>>   - compatible : Should be from the list
>> @@ -14,6 +15,7 @@ Required properties:
>>     ti,tps65913
>>     ti,tps65914
>>     ti,tps80036
>> +  ti,tps659038
>>   and also the generic series names
>>     ti,palmas
>>   - interrupt-controller : palmas has its own internal IRQs
> Applied.

Thanks Lee Jones.

>

