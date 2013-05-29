Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab3E2QdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:33:01 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57865 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3E2Qcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:32:53 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Cc: J Keerthy <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] PM / AVS: SmartReflex: disable errgen before vpbound disable
References: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com>
	<1369652846-14412-2-git-send-email-andrii.tseglytskyi@ti.com>
	<87sj17aqq2.fsf@linaro.org> <51A5D148.8050203@ti.com>
	<51A60F86.4090900@ti.com>
Date: Wed, 29 May 2013 09:32:50 -0700
In-Reply-To: <51A60F86.4090900@ti.com> (Andrii Tseglytskyi's message of "Wed,
	29 May 2013 17:24:06 +0300")
Message-ID: <87ehcp926l.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:

> On 05/29/2013 12:58 PM, Andrii Tseglytskyi wrote:
>> Hi Kevin,
>>
>> Thanks a lot for your comments.
>>
>> On 05/28/2013 09:45 PM, Kevin Hilman wrote:
>>> Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:
>>>
>>>> From: Nishanth Menon <nm@ti.com>
>>>>
>>>> vpboundsintr_en is available inside the IP block as an re-sycned
>>>> version and one which is not. Due to this, there is an 1 sysclk
>>>> cycle window where interruptz could be asserted low for 1 cycle.
>>>                               ^^^
>>>
>>> Is that the way the cool kidz are spelling interrupts these days?  ;)
>>
>> Oh! Shame on me. Thank you for catching this :)
>
> Shame on me again (((. Name "interruptz" is more less OK. This is the
> name of signal between Voltage Processor and SmartReflex.
> In documentation it is referenced as "SR_SInterruptz". Anyway commit
> message should be updated to make this more clear.

Ah, OK.  Makes sense now.  

Yes, the changlog should be more clear that this is referring to a
signal name, e.g. 

       ...there is an 1 sysclk cycle window where the SR_SInterruptz
       signal could be asserted low.

(also note that I think the  "for once cycle" that ends that phrase in
the original changelog is redundant, since it already says a "1 sysclk
cycle window".

Kevin

