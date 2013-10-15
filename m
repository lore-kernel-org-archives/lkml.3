Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab3JORJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:09:32 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:35542 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab3JORJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:09:30 -0400
Message-ID: <525D76C2.1020406@gmail.com>
Date: Tue, 15 Oct 2013 19:09:22 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] ARM: add Marvell Berlin SoC familiy to Marvell doc
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-5-git-send-email-sebastian.hesselbarth@gmail.com> <525C7993.40408@gmail.com> <20131015111039.6a7e664b@xhacker>
In-Reply-To: <20131015111039.6a7e664b@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 05:10 AM, Jisheng Zhang wrote:
> Hi Sebastian,
>
> On Mon, 14 Oct 2013 16:09:07 -0700
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> On 10/08/2013 02:24 PM, Sebastian Hesselbarth wrote:
>>> This adds known facts and rumors about the Marvell Berlin (88DE3xxx) SoC
>>> family to the Marvell SoC documentation.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
>>> Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>>> ---
>>> Changelog:
>>> RFCv2->v1:
>>> - move Berlin below PXA/MMP[23] where it belongs to
>>> - add note about IP (re-)used in Berlin SoCs
>>> RFCv1->RFCv2:
>>> - initial patch
>>>
>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Rob Landley <rob@landley.net>
>>> Cc: linux-doc@vger.kernel.org
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>    Documentation/arm/Marvell/README |   29 +++++++++++++++++++++++++++++
>>>    1 file changed, 29 insertions(+)
>>>
>>> diff --git a/Documentation/arm/Marvell/README
>>> b/Documentation/arm/Marvell/README index 8f08a86..993c45d 100644
>>> --- a/Documentation/arm/Marvell/README
>>> +++ b/Documentation/arm/Marvell/README
>>> @@ -210,6 +210,35 @@ MMP/MMP2 family (communication processor)
>>>       Linux kernel mach directory: arch/arm/mach-mmp
>>>       Linux kernel plat directory: arch/arm/plat-pxa
>>>
>>> +Berlin family (Digital Entertainment)
>>> +-------------------------------------
>>> +
>>> +  Flavors:
>>> +	88DE3005, Armada 1500-mini
>>> +		Design name:	BG2CD(A0)
>>> +		Core:		ARM Cortex-A9, PL310 L2CC
>>> +		Homepage:
>>> http://www.marvell.com/digital-entertainment/armada-1500-mini/
>>> +	88DE3010, Armada 1000
>>> +		Design name:	BG2(?)
>>> +		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
>>> +		Product Brief:
>>> http://www.marvell.com/digital-entertainment/assets/armada_1000_pb.pdf
>>> +	88DE3100, Armada 1500
>>> +		Design name:	BG2(A0)
>>> +		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
>>> +		Homepage:
>>> http://www.marvell.com/digital-entertainment/armada-1500/
>>> +		Product Brief:
>>> http://www.marvell.com/digital-entertainment/armada-1500/assets/Marvell-ARMADA-1500-Product-Brief.pdf
>>> +	88DE????
>>> +		Design name:	BG3
>>> +		Core:		ARM Cortex-A15, CA15 integrated L2CC
>>
>> Jisheng,
>>
>> can you comment on the above and fill in the missing pieces?
>>
>> Especially, if we want to base device tree compatibles later, we should
>> make it right in the first place.
>>
>
> Sorry, I can't leak some information now. So could we remove the BG3 and 88DE3010 sections?
> I promise I will update those information when I submit BG3 enable patches in near future.

Ok, but I leave the place-holders above for you to remember ;)

One last question: Can you at least tell what pl310 revision (e.g. r0p0
or r2p0) Tauros3's aux_ctrl is compatible with?

Sebastian

