Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3A1COd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:14:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A1COa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:14:30 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-86-5105df052a40
Message-id: <5105DEF0.5000507@samsung.com>
Date: Mon, 28 Jan 2013 11:14:08 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: fix to refer NULL pointer
References: <1359177589-13868-1-git-send-email-jy0922.shim@samsung.com>
 <Pine.LNX.4.64.1301270906270.5137@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1301270906270.5137@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zTV3W+6yBBj9nclhc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ6911jKWjhr5h7cQVLA+Nmni5GTg4JAROJT4uus0DY
	YhIX7q1n62Lk4hASWMYocXzFZ2aYorsrvzBDJBYxStxuW88E4bxklJh+9A4jSBWvgJbE+j0P
	2UBsFgFVicl334PF2QR0JLZ/O84EYosKhEmsnH6FBaJeUOLH5HtgtoiAocSpbRvAtjELlEs8
	PzoFKM7BISxgLHHrcjiIKSRQLXF6bTmIySlgJzHzXwVEsY7E/tZpbBC2vMTmNW/BzpQQ6GaX
	aJrWywxxjYDEt8mHwCZKCMhKbDoA9ZakxMEVN1gmMIrNQnLPLCRjZyEZu4CReRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGSGRI7WBc2WBxiFGAg1GJh/dHGkugEGtiWXFl7iFGCQ5mJRHe
	mDOsgUK8KYmVValF+fFFpTmpxYcYk4EOnMgsJZqcD4zavJJ4Q2MDY0NDS0MzU0tTA9KElcR5
	GU89CRASSE8sSc1OTS1ILYLZwsTBKdXAyFw6vbN4d8NuNxENGZblO3gMyp9z/4nK49tyQE9D
	QDbfIzG4bbVbrfZq/XUinP8KBVeX7a5KYAkJd3f+ohJyOHbLwdkqrG5MrFcCv2b/KvFf3SGw
	7+KkopWtRzxOHVCsjEv2v8ivUBHbEiP8oOdWqoOGY3ai8hEj9Udn6vZK6W7vWucd4aDEUpyR
	aKjFXFScCAD5e+m10AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAV3W+6yBBm/vM1lc3jWHzeLI/35G
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzevddYylo4a+Y
	e3EFSwPjZp4uRk4OCQETibsrvzBD2GISF+6tZ+ti5OIQEljEKHG7bT0ThPOSUWL60TuMIFW8
	AloS6/c8ZAOxWQRUJSbffQ8WZxPQkdj+7TgTiC0qECaxcvoVFoh6QYkfk++B2SIChhKntm0A
	28YsUC7x/OgUoDgHh7CAscSty+EgppBAtcTpteUgJqeAncTMfxUQxToS+1unsUHY8hKb17xl
	nsAoMAvJ/FlIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjunkntYFzZYHGI
	UYCDUYmH90caS6AQa2JZcWXuIUYJDmYlEd6YM6yBQrwpiZVVqUX58UWlOanFhxiTgd6fyCwl
	mpwPTAl5JfGGxiZmRpZGZsYm5sbGpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoHR9Pbj
	jXNsOypaYx2e+GgdNJgx8bLFS82o+rCOvhvn5mwz/637Wj2y8uaChhrHABO+31355wMYz/Fu
	d5ZuZnonkSAj+0To8FwOtguKP04qxS061HRENdc9lWelNGd6h6sK77sl4mtsXOacE39px/2u
	/FfFlcr2aSYibp9tXC/LKc33vHe4/o8SS3FGoqEWc1FxIgDI1LbA/wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 05:10 PM, Guennadi Liakhovetski wrote:
> On Sat, 26 Jan 2013, Joonyoung Shim wrote:
> 
>> Check whether host->sdio_irq_thread is NULL before wake_up_process() is
>> called about host->sdio_irq_thread.
> 
> Actually, mmc_signal_sdio_irq() shouldn't be called if SDIO IRQ isn't 
> used...
Right, But I think that need to check whether the host->sdio_irq_thread is assigned or not.

Best Regards,
Jaehoon Chung
> 
> Thanks
> Guennadi
> 
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> ---
>> Currently the kernel panic to refer NULL pointer about
>> host->sdio_irq_thread are occuring at the trats board using Samsung
>> SDHCI driver.
>>
>>  include/linux/mmc/host.h |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index 61a10c1..2950fea 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -372,7 +372,8 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
>>  {
>>  	host->ops->enable_sdio_irq(host, 0);
>>  	host->sdio_irq_pending = true;
>> -	wake_up_process(host->sdio_irq_thread);
>> +	if (host->sdio_irq_thread)
>> +		wake_up_process(host->sdio_irq_thread);
>>  }
>>  
>>  #ifdef CONFIG_REGULATOR
>> -- 
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

