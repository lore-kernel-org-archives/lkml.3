Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966768Ab3E2PFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:05:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48274 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966289Ab3E2PFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:05:42 -0400
Message-ID: <51A60F86.4090900@ti.com>
Date: Wed, 29 May 2013 17:24:06 +0300
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: J Keerthy <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] PM / AVS: SmartReflex: disable errgen before vpbound
 disable
References: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com> <1369652846-14412-2-git-send-email-andrii.tseglytskyi@ti.com> <87sj17aqq2.fsf@linaro.org> <51A5D148.8050203@ti.com>
In-Reply-To: <51A5D148.8050203@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 12:58 PM, Andrii Tseglytskyi wrote:
> Hi Kevin,
>
> Thanks a lot for your comments.
>
> On 05/28/2013 09:45 PM, Kevin Hilman wrote:
>> Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:
>>
>>> From: Nishanth Menon <nm@ti.com>
>>>
>>> vpboundsintr_en is available inside the IP block as an re-sycned
>>> version and one which is not. Due to this, there is an 1 sysclk
>>> cycle window where interruptz could be asserted low for 1 cycle.
>>                               ^^^
>>
>> Is that the way the cool kidz are spelling interrupts these days?  ;)
>
> Oh! Shame on me. Thank you for catching this :)

Shame on me again (((. Name "interruptz" is more less OK. This is the 
name of signal between Voltage Processor and SmartReflex.
In documentation it is referenced as "SR_SInterruptz". Anyway commit 
message should be updated to make this more clear.


[snip]
>
>

Regards,
Andrii

