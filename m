Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3EXECy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:02:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44137 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3EXECw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:02:52 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ab-519ee66b3427
Message-id: <519EE672.9060508@samsung.com>
Date: Fri, 24 May 2013 13:02:58 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Felipe Ferreri Tonello <eu@felipetonello.com>, linux-mmc@vger.kernel.org,
        ben-linux@fluff.org, cjb@laptop.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: sdhci: Added set_power sdhci_ops handler.
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
 <1369244832-23868-2-git-send-email-eu@felipetonello.com>
 <Pine.LNX.4.64.1305222230050.19558@axis700.grange>
 <2537252.KzShHU8h54@localhost.localdomain>
 <Pine.LNX.4.64.1305230920430.23354@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1305230920430.23354@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkSDf72bxAgy2/2Cz+TjrGbjFp3QEm
	i+2vN7JZdM4/y27xfuM8JovLu+awWRz538/owO7x+9ckRo+7Xx+ye/xd9YLZ48PHOI9DV9Yy
	enzeJBfAFsVlk5Kak1mWWqRvl8CVMbdjF1PBC76KWUcnMjYwvuDuYuTkkBAwkbjZ8Z8VwhaT
	uHBvPVsXIxeHkMBSRonGZw/YYYr+P7vPCpFYxCgxbcsKKOclo8T6Za1g7bwCWhL7Xt5iArFZ
	BFQlji8+xwZiswnoSGz/dhwsLioQJrGpp5kJol5Q4sfkeywgtoiAocSpbRuYQYYyg2z4tOw7
	M0hCWMBdov3XPhaIbdOYJE43tAPdxMHBKWAvsepeCUgNM9CC/a3T2CBseYnNa96CDZIQuMYu
	Mef3P2aIiwQkvk0+xALSKyEgK7HpADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJ
	BcVJ6UUmesWJucWleel6yfm5mxiBMXj637MJOxjvHbA+xJgMtHIis5Rocj4whvNK4g2NzYws
	TE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjE2DDAS8+xReia
	St7bAKekJzzbyw6krNoaKL/k/Msq/t1lv4taVjxdxnjrxwv3wwsl6v983nYv9+GlXY/u6U3g
	4JghwvinMNHSRWzdn6UX2VM6i4sSjcp3672vYcmcwWhx9+opy6uXmc5/WDtlx+GclZyLpriW
	P3Z5tc//gMXC0PMxmgXLjB4psRRnJBpqMRcVJwIA5lDsQ9cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd2sZ/MCDaafsrH4O+kYu8WkdQeY
	LLa/3shm0Tn/LLvF+43zmCwu75rDZnHkfz+jA7vH71+TGD3ufn3I7vF31Qtmjw8f4zwOXVnL
	6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0C1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoy5HbuYCl7wVcw6
	OpGxgfEFdxcjJ4eEgInE/2f3WSFsMYkL99azdTFycQgJLGKUmLZlBSuE85JRYv2yVrAqXgEt
	iX0vbzGB2CwCqhLHF59jA7HZBHQktn87DhYXFQiT2NTTzARRLyjxY/I9FhBbRMBQ4tS2Dcwg
	Q5lBNnxa9p0ZJCEs4C7R/msfC8S2aUwSpxva2bsYOTg4BewlVt0rAalhBlqwv3UaG4QtL7F5
	zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP8mfQOxlUN
	FocYBTgYlXh4Z+jMCxRiTSwrrsw9xCjBwawkwlsYBhTiTUmsrEotyo8vKs1JLT7EmAwMgonM
	UqLJ+cDkk1cSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjHx5
	ab/fHT7dNP/GrF0JOzzf9eqXV16QND1i1uHz2yjkSuUb5Y1RJiut5109wa8xy/N0Yc7nvW9S
	9iYc+j9BYXs3u/vB/B1FfhXrrPnFWi/Har2Q6q1ybZTQntGnckMxbW/RrU9n9r18bnFKzN+u
	Ma/32tKn7o2mt/uXFM/c5VZzWWO+2KkwayWW4oxEQy3mouJEAFkD+O40AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 04:25 PM, Guennadi Liakhovetski wrote:
> On Wed, 22 May 2013, Felipe Ferreri Tonello wrote:
> 
>> Hi Guennadi,
>>
>> On Wednesday, May 22, 2013 10:30:40 PM Guennadi Liakhovetski wrote:
>>> On Wed, 22 May 2013, Felipe F. Tonello wrote:
>>>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>>>
>>>> This is useful for power managment purposes if a sdhci child host wants to
>>>> turn off some other peripheral also.
>>>
>>> Sorry, could you elaborate a bit? In what situations is it exactly useful?
>>> And why cannot the regulator API be used there?
>>
>> Sorry about that.
>>
>> One example that I can think of is when you have a wifi module connected as a 
>> mmc card via sdio. So you can register a callback function in your machine 
>> source code to turn on/off the wifi module based on the mmc host power.
> 
> Ok, understand. Your second patch in this series adds such a callback in 
> your SDHCI host driver and there it just calls a platform callback. I 
> don't think this is a good idea. First, we want to go away from platform 
> callbacks, because they are incompatible with DT. Second, because the 
> proper solution IMHO would be for your platform to export a regulator, and 
> the SDHCI core driver already includes regulator support.
We can use the regulator framework.
i think this callback function didn't need.

Best Regards,
Jaehoon Chung
> 
>> I've seen this implementation in others mmc hosts, such as omap.
> 
> Which, however, doesn't yet mean, it's a good idea :)
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

