Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbbAOBxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:53:03 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56700 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbbAOBw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:52:59 -0500
Message-ID: <54B71D73.1030800@gmail.com>
Date: Wed, 14 Jan 2015 17:52:51 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        "arm@kernel.org" <arm@kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: update brcmstb entries
References: <1414521895-12667-1-git-send-email-f.fainelli@gmail.com>	<1414521895-12667-2-git-send-email-f.fainelli@gmail.com>	<20141104204514.GA5908@quad.lixom.net>	<545957A5.6010802@gmail.com>	<CACxGe6s5rCUM_QQ-Da-AOKBbb4tUEJ_rcKU9frdEDDprYND3Tw@mail.gmail.com>	<54595FED.6000409@gmail.com> <CAN8TOE_uHUFuyofTYFzWioB7TkCqx2sLYk2bbrV06EKOMvzYRg@mail.gmail.com>
In-Reply-To: <CAN8TOE_uHUFuyofTYFzWioB7TkCqx2sLYk2bbrV06EKOMvzYRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 16:13, Brian Norris wrote:
> Since I found this in my inbox during garbage collection...
> 
> On Tue, Nov 4, 2014 at 3:23 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 11/04/2014 02:56 PM, Grant Likely wrote:
>>> On Tue, Nov 4, 2014 at 10:48 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>> On 11/04/2014 12:45 PM, Olof Johansson wrote:
>>>>> On Tue, Oct 28, 2014 at 11:44:54AM -0700, Florian Fainelli wrote:
>>>>>> Remove Marc Carino from the brcmstb maintainers list and add Gregory
>>>>>> Fong and myself as new maintainers for the brcmstb platform.
>>>>>>
>>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>>> ---
>>>>>>  MAINTAINERS | 3 ++-
>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>>> index dab92a78d1d5..33a8b31e03f0 100644
>>>>>> --- a/MAINTAINERS
>>>>>> +++ b/MAINTAINERS
>>>>>> @@ -2093,8 +2093,9 @@ F:     arch/arm/mach-bcm/bcm63xx.c
>>>>>>  F:  arch/arm/include/debug/bcm63xx.S
>>>>>>
>>>>>>  BROADCOM BCM7XXX ARM ARCHITECTURE
>>>>>> -M:  Marc Carino <marc.ceeeee@gmail.com>
>>>>>>  M:  Brian Norris <computersforpeace@gmail.com>
>>>>>> +M:  Gregory Fong <gregory.0xf0@gmail.com>
>>>>>> +M:  Florian Fainelli <f.fainelli@gmail.com>
>>>>>
>>>>> You're removing Marc here, but I don't see an ack from him, nor has
>>>>> he been cc:d on the patch. It's common practice for people to agree to
>>>>> being removed. Can you please make sure we get an ack from him on this,
>>>>> maybe by reposting and cc:ing him?
>>>>
>>>> Marc is no longer with Broadcom, do you still want him to ack this?
>>>
>>> Yes, absolutely. Maintainership is entrusted to an individual, not
>>> their employer. We've had many situations where someone has continued
>>> to maintain a platform even after changing employment. So, yes, there
>>> needs to be an ack from Marc.
>>
>> He is CC'd, now. Marc, please Ack this if you are okay with the change.
> 
> Can we add a "Not-nacked-by" tag and proceed? Marc is obviously not
> involved here any more. I figure removing expired maintainers should
> be a little easier than removing SCOTUS judges.

You'd think so right? How about this plan: unless Marc replies
otherwise, I submit a MAINTAINERS update removing him for the v3.21
kernel release?
-- 
Florian
