Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3KZWlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:41:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10013 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab3KZWlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:41:32 -0500
X-AuditID: cbfee690-b7f126d00000418c-c5-5295239bd95e
Message-id: <5295239B.7070608@samsung.com>
Date: Wed, 27 Nov 2013 07:41:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: gpio: Request gpio pin before modifying its state
References: <1385141161-7785-1-git-send-email-linux@roeck-us.net>
 <52945409.5040502@samsung.com> <52948F0E.9080303@roeck-us.net>
In-reply-to: <52948F0E.9080303@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkQHe28tQgg8VdEhaXd81hs3iy8AyT
	xe3GFWwOzB47vzewe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfGs/MSBd85Kvp6HzE3MM5k
	72Lk5JAQMJF4uu43G4QtJnHh3nogm4tDSGApo8SpdSdZYIoWHF3HDpFYxCix/M5iRgjnFaPE
	lA0LWEGqeAW0JI7tf8gMYrMIqErcbnvPBGKzAcX3v7gBtkJUIExi5fQrLBD1ghI/Jt8Ds0UE
	1CSaT7WA1TALeEqcvtUFNkdYwE+i698/VohlTYwS3+/dAiviFNCRmPJ4CStEg47E/tZpUM3y
	EpvXvGUGaZAQmMcu0f61G+oiAYlvkw8BbeMASshKbDrADPGapMTBFTdYJjCKzUJy0ywkY2ch
	GbuAkXkVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmD0nP73bMIOxnsHrA8xJgOtnMgsJZqc
	D4y+vJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg
	XCnp1xjm9fdnZZ/koo4ep8UN512K+ifsEpRIn7i95H3AiumNKZ9nH7OaV392ljX3MVXrYj0T
	maB9+4r7Z4gcWPjIb/9Hgac/VLRn/cpZuctaJUkoWLvCTl9Ekk0qbZ31YuaEpJ0rNM7M0ms/
	wH/vjvrL4oU/pGV/3sv4mpfc/XvjDvFflW9FlFiKMxINtZiLihMBlcg92rQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jAd3ZylODDO42CFpc3jWHzeLJwjNM
	FrcbV7A5MHvs/N7A7tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGc/OSxR856jo633E3MA4k72LkZNDQsBEYsHRdVC2mMSFe+vZuhi5OIQEFjFKLL+z
	mBHCecUoMWXDAlaQKl4BLYlj+x8yg9gsAqoSt9veM4HYbEDx/S9usIHYogJhEiunX2GBqBeU
	+DH5HpgtIqAm0XyqBayGWcBT4vStLrA5wgJ+El3//rFCLGtilPh+7xZYEaeAjsSUx0tYIRp0
	JPa3ToNqlpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMGx+UxqB+PKBotDjAIcjEo8vBMuTwkSYk0sK67MPcQowcGsJMJrqjA1SIg3JbGyKrUoP76o
	NCe1+BBjMjAIJjJLiSbnA9NGXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwNid4WXwKWHy/4cSmoqv/QpJSP4X0S7WedXrP1R/L6e7wg0XPqfVKeD6X3O/I
	ytZfu6bdum6Q8PDEzKh2odPT5qUJWb9jniUwW/rUItHWaO9Vr7Ok/393P5YxUeudxVXtRz+6
	uj4XH8xWDX0Rx7Tk/17bxC8PvzJ+d5cw9xb4FGjl0Lf5xUMrJZbijERDLeai4kQAZe2vwRED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 09:07 PM, Guenter Roeck wrote:
> On 11/25/2013 11:55 PM, Chanwoo Choi wrote:
>> Hi Guenter,
>>
>> On 11/23/2013 02:26 AM, Guenter Roeck wrote:
>>> Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
>>> introduced a call to gpio_set_debounce() before actually requesting the
>>> respective gpio pin from the gpio subsystem.
>>>
>>> The gpio subsystem expects that a gpio pin was requested before modifying its
>>> state. Not doing so results in a warning from gpiolib, and the gpio pin is
>>> auto-requested. This in turn causes the subsequent devm_gpio_request_one()
>>> to fail. So devm_gpio_request_one() must be called prior to calling
>>> gpio_set_debounce().
>>>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>>   drivers/extcon/extcon-gpio.c |   11 ++++++-----
>>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>
>> Applid it on extcon-next branch.
>>
> 
> As this is a bug fix, I think it would make sense to have this applied to the current
> kernel and not wait for 3.14.
> 

OK, I move it on extcon-linus branch.

Thanks,
Chanwoo Choi

