Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3HMKF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:05:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62637 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab3HMKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:05:58 -0400
X-AuditID: cbfee68f-b7f436d000000f81-dd-520a05041a1a
Message-id: <520A0504.6060203@samsung.com>
Date: Tue, 13 Aug 2013 19:05:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] extcon: arizona: Clear trig_sts bits on all paths
References: <1375874234-30549-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1375874234-30549-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkQJeFlSvIYNNBbYsrFw8xWUx9+ITN
	4t+UG+wWl3fNYbO43biCzWL52/9sDmweGz43sXlsWtXJ5vFy4m82j74tqxg9Pm+SC2CN4rJJ
	Sc3JLEst0rdL4MroOLmMpWAHd8XBLQeYGhiXcHYxcnJICJhI7P3ZygRhi0lcuLeeDcQWEljK
	KPHuYglMzZ1Jt4HiXEDxRYwSZ6Y8YoRwXjFK/JmxnRGkildAS2LO9yZ2EJtFQFVi1+3PYDYb
	UHz/ixtgU0UFwiRWTr/CAlEvKPFj8j0wW0TAQmLKklvMIEOZBaYwSsz49xfsJGEBT4kpE3qY
	IU4KlTh68yLYIE6gQZ/bV4PFmQV0JPa3TmODsOUlNq95CzZIQuAYu0TD5OWsEBcJSHybfAho
	GwdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguKk9KLjPWKE3OLS/PS
	9ZLzczcxAuPt9L9n/TsY7x6wPsSYDLRyIrOUaHI+MF7zSuINjc2MLExNTI2NzC3NSBNWEudV
	a7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDYznn6A7ezf/2rfbzstz7se+G41SJQdrvB
	h43Xtq/btqwyg8M54ruI6YIlEiX8reJPJvw7fztFlLGJfRX7jn2Tat2me/ZJpPKwVt2U7Ki6
	dfbt7JIozWPHiuVDpe84ZCrnSV5tYdny5tg+pY93H7WdXtxb1Dv92WfO1//29vi/4J116p/0
	iRcrlViKMxINtZiLihMB8/o1Z80CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAV0WVq4ggxuflC2uXDzEZDH14RM2
	i39TbrBbXN41h83iduMKNovlb/+zObB5bPjcxOaxaVUnm8fLib/ZPPq2rGL0+LxJLoA1qoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoBCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRsfJZSwFO7grDm45wNTAuISzi5GT
	Q0LAROLOpNtsELaYxIV764FsLg4hgUWMEmemPGKEcF4xSvyZsZ0RpIpXQEtizvcmdhCbRUBV
	Ytftz2A2G1B8/4sbYJNEBcIkVk6/wgJRLyjxY/I9MFtEwEJiypJbzCBDmQWmMErM+PeXCSQh
	LOApMWVCDzOILSQQKnH05kWwQZxAgz63rwaLMwvoSOxvncYGYctLbF7zlnkCo8AsJDtmISmb
	haRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgeH4mvYNxVYPFIUYBDkYlHt6MjxxB
	QqyJZcWVuYcYJTiYlUR44xi5goR4UxIrq1KL8uOLSnNSiw8xJgODYCKzlGhyPjDV5JXEGxqb
	mBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY1qsdavkMcckySnMfSIK
	SYfWfa5TvyMcz1nOu7cyc+39PQpHdy3U608JfcnNaiyyzU7UO41p3Y7Z0ktbF0YoLYn+cPJY
	27ofZ0oWdfeurW4XjCr5m6nfwMsmd/veklUup/+I1oomtk0+Jz1Tr6zvzIFKJe9Wm68HWO6m
	uL+dLTvj4iHXwqLNSizFGYmGWsxFxYkAIJuf1isDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 08/07/2013 08:17 PM, Charles Keepax wrote:
> We want the trig_sts bits to be cleared in all cases where we consider
> the jack detection interrupt to have been handled. Specifically, if a
> duplicate detection event was suppressed these bits were not cleared
> causing the CODEC to not enter a low power state. This patch clears the
> bits on the duplicate detection code path.
> 
> Reported-by: Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 7a1b4a7..4df68de 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1034,6 +1034,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
>  	else
>  		info->micd_timeout = DEFAULT_MICD_TIMEOUT;
>  
> +out:
>  	/* Clear trig_sts to make sure DCVDD is not forced up */
>  	regmap_write(arizona->regmap, ARIZONA_AOD_WKUP_AND_TRIG,
>  		     ARIZONA_MICD_CLAMP_FALL_TRIG_STS |
> @@ -1041,7 +1042,6 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
>  		     ARIZONA_JD1_FALL_TRIG_STS |
>  		     ARIZONA_JD1_RISE_TRIG_STS);
>  
> -out:
>  	mutex_unlock(&info->lock);
>  
>  	pm_runtime_mark_last_busy(info->dev);
> 

Applied it.

Thanks.
Chanwoo Choi
