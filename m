Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaDOIvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:51:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaDOIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:51:18 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-5b-534cf300dbd5
Message-id: <534CF303.6050100@samsung.com>
Date: Tue, 15 Apr 2014 17:51:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, olof@lixom.net, marc.zyngier@arm.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <4788081.xvaJfdGTMu@wuerfel> <534CEEA8.6020800@samsung.com>
 <5677551.At1Foxml9e@wuerfel>
In-reply-to: <5677551.At1Foxml9e@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSrMvw2SfYYNttbYu/k46xW0xad4DJ
	4vJ+bYv5R86xWnz+0MJu0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsbl/mtfh75x+bxanr
	n4FCk1+yWayf8ZrF4tiMJYwWe3dOZnQQ9Fgzbw2jR0tzD5vH71+TGD3+rnrB7HHn2h42j81L
	6j2unGhi9ejbsorR4/MmuQDOKC6blNSczLLUIn27BK6M1c/2sxQc5Kg48v0eUwPjE7YuRk4O
	CQETiY5zHxkhbDGJC/fWA8W5OIQEljJKfJz5Cq5o6b6fjBCJRYwSn7cdY4dwXjNK/H/RBVbF
	K6AlsXXFPmYQm0VAVeLXnL3sIDYbUHz/ixtgNaICYRIrp19hgagXlPgx+R6YLSKgKDH1xTNm
	kKHMAkuZJeYu/AN2k7CAj8TLq+vY4VYvO9YA1sEpoCnxZ1IvWBGzgI7E/tZpbBC2vMTmNW/B
	JkkIrOSQ2N5+kBXiJAGJb5MPATVzACVkJTYdYIb4TVLi4IobLBMYxWYhOWoWkrGzkIxdwMi8
	ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwBZz+96x3B+PtA9aHGJOBVk5klhJNzgemkLyS
	eENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDT9bVZ0
	5JqmYnih9VIDE88O1sllLTaVO6f7PmHTMur11v+qMTPVX/HK719ZQYcTsl5yPW9fkhZbO8tm
	U2SkR8me27O3RLy/LtutF/K+ne9T3be1yus2X/zhcvTWdAXBXe3iG03vB/wInrQnjHlmQED0
	/XTegycmljTpKe9fLTNB2uOX77qPGUosxRmJhlrMRcWJAPnyRYMXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAV2Gzz7BBsfnKln8nXSM3WLSugNM
	Fpf3a1vMP3KO1eLzhxZ2i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XfO//YLE5d
	/wwUmvySzWL9jNcsFsdmLGG02LtzMqODoMeaeWsYPVqae9g8fv+axOjxd9ULZo871/aweWxe
	Uu9x5UQTq0ffllWMHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAvaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxh
	zFj9bD9LwUGOiiPf7zE1MD5h62Lk5JAQMJFYuu8nI4QtJnHh3nqgOBeHkMAiRonP246xQziv
	GSX+v+gC6+AV0JLYumIfM4jNIqAq8WvOXnYQmw0ovv/FDbAaUYEwiZXTr7BA1AtK/Jh8D8wW
	EVCUmPriGTPIUGaBpcwScxf+AVstLOAj8fLqOna41cuONYB1cApoSvyZ1AtWxCygI7G/dRob
	hC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8wz
	6R2MqxosDjEKcDAq8fBOeOcdLMSaWFZcmXuIUYKDWUmE98tLn2Ah3pTEyqrUovz4otKc1OJD
	jMnAMJjILCWanA9Mfnkl8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwOhvO5tXhDc/2JVVdWsJr/bhgg33nygKK2+esahU14TrserznDnT16i4JzW+vL1Fx0dr
	9uNZIRrhbl7rRFbmt1QE26ZYJt5inhVk1/NFZ/69v65G/A77t4TvSznOsOGXysNpLW+jLsQG
	nXie/l6lqjT54a+T8jz3JTLiFpovWXw8tCbkb+fhGCWW4oxEQy3mouJEAJZvMuN0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 05:46 PM, Arnd Bergmann wrote:
> On Tuesday 15 April 2014 17:32:40 Chanwoo Choi wrote:
>> On 04/15/2014 05:11 PM, Arnd Bergmann wrote:
>>> On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
>>
>>> I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
>>> only.
>>
>> You are right. Sachin's patch only included the solution of SYSRAM memory mapping.
>> I set out the plan that I would implment proper driver for PMU memory mapping
>> instead of static method after merged Sachin's patch for SYSRAM.
>>
>> But,
>> If you'd like me to implment PMU memory mapping instead of static mapping right now,
>> I'll implement it for PMU such as Sachin's patch on next posting(v3).
> 
> I don't really want to merge a new SoC type until these are resolved, so
> it would definitely be better to implement this for v3.
> 

OK,
I'll rebase this patch on following patch which support PMU memory mapping through DT.

[1] http://www.spinics.net/lists/arm-kernel/msg316013.html

Thanks for your review.

Best Regards,
Chanwoo Choi

