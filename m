Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaLIOOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:14:25 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12702 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaLIONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-8b-5487038ad938
Message-id: <54870389.7070203@samsung.com>
Date: Tue, 09 Dec 2014 15:13:29 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com>
 <20141209140927.GL15559@valkosipuli.retiisi.org.uk>
In-reply-to: <20141209140927.GL15559@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xK7pdzO0hBjdPalvcWneO1WLjjPWs
	Fkd3TmSyuP7lOavF/CNAsf43C1ktzr1ayWhxtukNu8X9r0cZLS7vmsNmsfXNOkaLng1bWS2W
	Xr/IZHH31FE2iwnT17JYtO49wm6xe9dTVovDb9pZLc7sX8nmIOyxZt4aRo/Lfb1MHjtn3WX3
	WLn8C5vH4a8LWTw2repk87hzbQ+bx575P1g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6
	dglcGZuevGQvaGSv+PlqGnsD4xHWLkZODgkBE4l/s6ZA2WISF+6tZ+ti5OIQEljKKLFgx1kW
	COcjo0TfjllsIFW8AloSi4GWgdgsAqoSTbu+sIDYbAKGEj9fvGYCsUUFIiT+nN7HClEvKPFj
	8j2wGhEBNYmnmx6CDWUWeMws0bZyNViRsECIxNb9p6G2TWGS6HtwmhEkwSngIPH0/0awImYB
	a4mVk7YxQtjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/
	dxMjJD6/7GBcfMzqEKMAB6MSD6+5YmuIEGtiWXFl7iFGCQ5mJRHeKUfbQoR4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUwqv2ROTft8eIpDdOWT7y+d3Vt1J5Lme5vszoSEnuuu+7vSzq4TWNtaZuA
	64acFt5lSSIinGsVViyalnVo7ZTdG21XyngzHH9lG55T/cL86Af2h1t/zVq1OPzkp0vdPlPC
	Qy9FZ78/2Hby3tcbk+dLKSq3qrZWFHxxNdkrzJ9v5/Oh348la/q840osxRmJhlrMRcWJANdd
	0vWtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 12/09/2014 03:09 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Dec 04, 2014 at 12:40:48PM +0100, Jacek Anaszewski wrote:
>>>> +			the flash/torch.
>>>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>>>> +	in order: fled1, fled2.
>>>> +	Possible flag values (can be combined):
>>>> +		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
>>>> +		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
>>>> +		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
>>>
>>> Is there a need to prevent strobing using a certain method? Just wondering.
>>
>> In some cases it could be convenient to prevent some options through
>> device tree.
>
> Do you have that need now?
>
> If not, I'd propose to postpone this and add it only if there ever is one.
>

No, I don't. So let's postpone it.

Best Regards,
Jacek Anaszewski
