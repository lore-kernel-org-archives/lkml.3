Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaK1Ksu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:48:50 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:49478 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaK1Kst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:48:49 -0500
Message-ID: <5478530B.3090102@atmel.com>
Date: Fri, 28 Nov 2014 11:48:43 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-kernel@vger.kernel.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <27354361.uIQEXGDqXb@wuerfel> <54784209.6070003@atmel.com> <2351041.YbSYt1FKtz@wuerfel>
In-Reply-To: <2351041.YbSYt1FKtz@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/2014 11:25, Arnd Bergmann wrote:
> On Friday 28 November 2014 10:36:09 Nicolas Ferre wrote:
>> On 27/11/2014 18:38, Arnd Bergmann wrote:
>>> On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
>>>> On 27/11/2014 at 17:49:50 +0100, Arnd Bergmann wrote :
>>>>> On Thursday 27 November 2014 17:06:28 Nicolas Ferre wrote:
>>>>>> This is the last series of patches that removes the non-Device-Tree board
>>>>>> support for older Atmel SoCs.
>>>>>> Again, for the record, it was announced here
>>>>>> https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
>>>>>> files) two months ago.
>>>>>> Several files beyond at91rm9200 are touched this time as I tried to remove the
>>>>>> biggest parts that were related to !DT SoC initializations. More cleanup is
>>>>>> certainly needed to remove dead code.
>>>>>>
>>>>>> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
>>>>>>
>>>>>
>>>>> Awesome stuff!
>>>>>
>>>>> Two questions:
>>>>>
>>>>> - is anything holding this up from getting merged in 3.19?
>>>>>
>>>>
>>>> If you think this is not too late in the cycle, I would say go ahead 
>>>
>>> I'd say we should do it, unless there are last-minute regressions.
>>
>> Arnd,
>>
>> I am totally in favor for a merge into 3.19.
>> I wanted to wait one day or two but given that the official announce had
>> been made several months ago, I don't think it makes a big difference.
>>
>> So, what do you prefer:
>>
>> 1/ I wait today and send you the pull-request this evening (our time)
>> 2/ I send you the pull-request at the beginning of next week but still
>> can make it for 3.19?
> 
> Just send the pull request whenever you have it ready. If some bug shows
> up, reply to that mail with an updated pull request.

Okay, I do it right now then.

Thanks Arnd.


>> (BTW, in the meantime, there is a pending pull-request (at91-cleanup3)
>> but it is true that you needn't pulling it in if you plan to take this
>> one which will be named at91-cleanup4 and that will obviously contain
>> the 3rd one).
> 
> Yes, I have a backlog of pull requests to look at, should get to that soon
> today.
> 
> 	Arnd
> 
> 


-- 
Nicolas Ferre
