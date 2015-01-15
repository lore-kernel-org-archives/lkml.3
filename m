Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbbAOANm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:13:42 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43521 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbAOANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <54595FED.6000409@gmail.com>
References: <1414521895-12667-1-git-send-email-f.fainelli@gmail.com>
	<1414521895-12667-2-git-send-email-f.fainelli@gmail.com>
	<20141104204514.GA5908@quad.lixom.net>
	<545957A5.6010802@gmail.com>
	<CACxGe6s5rCUM_QQ-Da-AOKBbb4tUEJ_rcKU9frdEDDprYND3Tw@mail.gmail.com>
	<54595FED.6000409@gmail.com>
Date: Wed, 14 Jan 2015 16:13:40 -0800
Message-ID: <CAN8TOE_uHUFuyofTYFzWioB7TkCqx2sLYk2bbrV06EKOMvzYRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: update brcmstb entries
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        "arm@kernel.org" <arm@kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I found this in my inbox during garbage collection...

On Tue, Nov 4, 2014 at 3:23 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 11/04/2014 02:56 PM, Grant Likely wrote:
>> On Tue, Nov 4, 2014 at 10:48 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> On 11/04/2014 12:45 PM, Olof Johansson wrote:
>>>> On Tue, Oct 28, 2014 at 11:44:54AM -0700, Florian Fainelli wrote:
>>>>> Remove Marc Carino from the brcmstb maintainers list and add Gregory
>>>>> Fong and myself as new maintainers for the brcmstb platform.
>>>>>
>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>> ---
>>>>>  MAINTAINERS | 3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index dab92a78d1d5..33a8b31e03f0 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -2093,8 +2093,9 @@ F:     arch/arm/mach-bcm/bcm63xx.c
>>>>>  F:  arch/arm/include/debug/bcm63xx.S
>>>>>
>>>>>  BROADCOM BCM7XXX ARM ARCHITECTURE
>>>>> -M:  Marc Carino <marc.ceeeee@gmail.com>
>>>>>  M:  Brian Norris <computersforpeace@gmail.com>
>>>>> +M:  Gregory Fong <gregory.0xf0@gmail.com>
>>>>> +M:  Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>> You're removing Marc here, but I don't see an ack from him, nor has
>>>> he been cc:d on the patch. It's common practice for people to agree to
>>>> being removed. Can you please make sure we get an ack from him on this,
>>>> maybe by reposting and cc:ing him?
>>>
>>> Marc is no longer with Broadcom, do you still want him to ack this?
>>
>> Yes, absolutely. Maintainership is entrusted to an individual, not
>> their employer. We've had many situations where someone has continued
>> to maintain a platform even after changing employment. So, yes, there
>> needs to be an ack from Marc.
>
> He is CC'd, now. Marc, please Ack this if you are okay with the change.

Can we add a "Not-nacked-by" tag and proceed? Marc is obviously not
involved here any more. I figure removing expired maintainers should
be a little easier than removing SCOTUS judges.

Brian
