Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaLKMwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:52:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26230 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933747AbaLKMv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:57 -0500
X-AuditID: cbfee68f-f791c6d000004834-42-5489936aeb0f
Message-id: <5489936A.3010409@samsung.com>
Date: Thu, 11 Dec 2014 21:51:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] extcon: add MAX3355 driver
References: <14631865.01KLlU2iKL@wasted.cogentembedded.com>
 <5488F775.1030304@samsung.com> <54899264.30009@cogentembedded.com>
In-reply-to: <54899264.30009@cogentembedded.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkUDdrcmeIwe5T2hbzj5xjteh/s5DV
	4sCfHYwW516tZLS4vGsOm8WcP1OYLRYta2W2WHr9IpPF7cYVbBYTpq9lsWjde4Td4syqW+wO
	PB5r5q1h9Ljc18vk8WDqfyaPlcu/sHlsWtXJ5nHn2h42j74tqxg9Pm+SC+CI4rJJSc3JLEst
	0rdL4MrYNP8wc8Ft1oq+l58YGxhnsXQxcnJICJhILF9zkw3CFpO4cG89kM3FISSwlFHiTkM3
	K0zRtyt7GCES0xkl7v27CtYhJPCaUWLppiIQm1dAS2Lxh61gU1kEVCVuLpvDCGKzAcX3v7gB
	Vi8qECaxcvoVFoh6QYkfk++B2SICFhJ3GxexgCxgFpjPJDHxwAawBmEBfYkXF19DndTAKLHl
	70WmLkYODk4BA4muBzYgJrOAnsT9i1og5cwC8hKb17xlBimXEOjkkJj7+CIzxEECEt8mH2IB
	qZcQkJXYdIAZ4jFJiYMrbrBMYBSbheSkWQhTZyGZuoCReRWjaGpBckFxUnqRsV5xYm5xaV66
	XnJ+7iZGYBSf/vesfwfj3QPWhxgFOBiVeHgz4jtDhFgTy4orcw8xmgIdMZFZSjQ5H5gq8kri
	DY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSkF9Phjc7NXkz42
	Oy/k4+Wd2DVvkvfvJTeNbEvnlXGUnXQKKmbc9OlfbPNjia2iy99PNHzK2SnzQLXhY+jSPHFW
	Plfl9y3ztk945dagtf1Y4STm3hN/TkULnWtW3jQ7/9A9NsGLe47P+vG8/36H9cfzTO624u5m
	PsYr9kfm809MOH69Lvyab6v0XiWW4oxEQy3mouJEALX3TsbdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd2syZ0hBqdvKFvMP3KO1aL/zUJW
	iwN/djBanHu1ktHi8q45bBZz/kxhtli0rJXZYun1i0wWtxtXsFlMmL6WxaJ17xF2izOrbrE7
	8HismbeG0eNyXy+Tx4Op/5k8Vi7/wuaxaVUnm8eda3vYPPq2rGL0+LxJLoAjqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqb5h5kLbrNW9L38xNjAOIuli5GTQ0LAROLb
	lT2MELaYxIV769m6GLk4hASmM0rc+3eVDSQhJPCaUWLppiIQm1dAS2Lxh61gzSwCqhI3l80B
	a2YDiu9/cQOsXlQgTGLl9CssEPWCEj8m3wOzRQQsJO42LmIBWcAsMJ9JYuKBDWANwgL6Ei8u
	voba3MAoseXvRaYuRg4OTgEDia4HNiAms4CexP2LWiDlzALyEpvXvGWewCgwC8mKWQhVs5BU
	LWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnCKeSe1gXNlgcYhRgINRiYc3I74zRIg1
	say4MvcQowQHs5IIr1UEUIg3JbGyKrUoP76oNCe1+BCjKTAAJjJLiSbnA9NXXkm8obGJmZGl
	kbmhhZGxuZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QD48ILq8Jf2f/lfWtxVWxxNd83o5LD
	BkWMe4RaKteVP2G81zttZc7p9heXY/lfS984Uclfl+th7RkgcPDP6atbbp8Vk2heJTmHOaNS
	M+xRnKiP2yLGiSc/dmS9EZjWNH/6afXK+SvusvPkdpTa1ggKlF6aN7dE8+qOpVZS85mPVS0I
	uLnya9LEACWW4oxEQy3mouJEACim7YInAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 09:47 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 12/11/2014 4:46 AM, Chanwoo Choi wrote:
> 
>> I reviewed this patch quickly. This driver has just two gpio without any registers for IP.
> 
>    Because there are no registers.
> 
>> I wonder whether MAX3355E is separate chip to detect external connector
> 
>    Yes. I thought my description has made that clear...
> 
>> or just use gpio of AP.
> 
>    What do you mean by AP?
>    MAX3355 is indeed partly connected to GPIOs and partly to the USB pins.
> 
>> Could you send the datasheet of MAX3355E to me?
> 
>    Looks like Geert has beaten me to it. :-)
> 
>> Thanks,
>> Chanwoo Choi
> 

OK, I'll review it.

Thanks,
Chanwoo Choi

