Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3JKL0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:26:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64423 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3JKL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:26:46 -0400
X-Spam-Score: -100.8
Message-ID: <5257E033.3090607@asianux.com>
Date: Fri, 11 Oct 2013 19:25:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64: include: asm: atomic.h: use 'unsigned int'
 and 'atomic_t' instead of 'unsigned long' for atomic_clear_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com> <5256121A.9030504@asianux.com> <52561269.60900@asianux.com> <20131010100733.GH3817@mudshark.cambridge.arm.com> <52568998.2080108@asianux.com> <20131010142305.GG6199@mudshark.cambridge.arm.com> <525751E2.3020207@asianux.com> <20131011104419.GE14732@mudshark.cambridge.arm.com>
In-Reply-To: <20131011104419.GE14732@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 06:44 PM, Will Deacon wrote:
> On Fri, Oct 11, 2013 at 02:18:26AM +0100, Chen Gang wrote:
>> On 10/10/2013 10:23 PM, Will Deacon wrote:
>>> On Thu, Oct 10, 2013 at 12:03:52PM +0100, Chen Gang wrote:
>>>> BTW: do arm64 need atomic_clear_mask()?
>>>
>>> No. Neither ARM nor arm64 need this function.
>>
>> OK, thank you for your confirmation.
>>
>> Hmm... can we remove atomic_clear_mask() from ARM and arm64? (in my
>> opinion, if not need, better to remove it).
> 
> Yes!
> 

OK, thanks.

> I mentioned this a few times already...
> 

Hmm... firstly, you mentioned "except architectures, this is only used
under s390" (so I reply we need follow s390), and then you mentioned
"they are useless for arm/arm64" (so I ask whether it can be removed).

Excuse me, as a 'programmer' (at least, I am a 'programmer'), when
programming (assume our discussing belongs to programming), I have to
consider precisely (especially for confirmation words).  ;-)

I will send one patch for removing it from arm and arm64.

Thanks.

> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Thanks.
-- 
Chen Gang

-- 
Chen Gang
