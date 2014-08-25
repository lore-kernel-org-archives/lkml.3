Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaHYA5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 20:57:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51998 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaHYA5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 20:57:44 -0400
X-AuditID: cbfee68e-f79536d000000fd1-12-53fa89fdd262
Message-id: <53FA89FD.1030004@samsung.com>
Date: Mon, 25 Aug 2014 09:57:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv2 1/5] rtc: s3c: Define s3c_rtc structure to remove global
 variables.
References: <y@samsung.com> <1407808871-6046-1-git-send-email-y@samsung.com>
 <1407808871-6046-2-git-send-email-y@samsung.com>
 <20140822134204.1fa5be7aeb76a50b45ccc5f5@linux-foundation.org>
In-reply-to: <20140822134204.1fa5be7aeb76a50b45ccc5f5@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkUPdv569gg6tbTSyWXLzKbjFn/Ro2
	i94FV9kszja9Ybe4vGsOm8WM8/uYLPZ3djA6sHvsmXiSzePEjN8sHn1bVjF6TJ/3k8nj8ya5
	ANYoLpuU1JzMstQifbsErowlGxewFHyUrPj7r4GlgfGESBcjB4eEgInE3B7zLkZOIFNM4sK9
	9WxdjFwcQgJLGSVuTnjEBlPz7YwORHwRo0R71wVmCOc1o8S6cy2MIN28AloSKzc/ZQaxWQRU
	JV61X2QCsdmA4vtf3GADsUUFwiRWTr/CAlEvKPFj8j0wW0RAV2LV811gvcwCqxklXp3WB7GF
	BaIlfu38zAix7ACjRN+Om2DLOAW8Jdb2TGCFaNCR2N86jQ3ClpfYvOYt2HUSAufYJTYe3ccC
	cZGAxLfJh1gg3pGV2HSAGeJlSYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IiO9
	4sTc4tK8dL3k/NxNjMC4O/3vWd8OxpsHrA8xCnAwKvHwruD8FSzEmlhWXJl7iNEU6IqJzFKi
	yfnA6M4riTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR
	wEgj1Npna6D8jh8+wUZV6988WFQZzzlJvIT7u2ic9eeodWK/slfOkY9unZGYoPXZMX+PuGNC
	hlqslS5bUV2aSNfptas3TU0923ebM84vIi63QsJzy7GezZ9NXzw9L7p8o7qZzc99a969lp/9
	qaZpOnuvUF9oR+XsfqYehf8vBZPN6tNLGpVYijMSDbWYi4oTARsT4N22AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jAd2/nb+CDS6907ZYcvEqu8Wc9WvY
	LHoXXGWzONv0ht3i8q45bBYzzu9jstjf2cHowO6xZ+JJNo8TM36zePRtWcXoMX3eTyaPz5vk
	AlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLNm4gKXgo2TF338NLA2M
	J0S6GDk4JARMJL6d0eli5AQyxSQu3FvP1sXIxSEksIhRor3rAjOE85pRYt25FkaQKl4BLYmV
	m58yg9gsAqoSr9ovMoHYbEDx/S9usIHYogJhEiunX2GBqBeU+DH5HpgtIqArser5LrBeZoHV
	jBKvTuuD2MIC0RK/dn5mhFh2gFGib8dNsGWcAt4Sa3smsEI06Ejsb53GBmHLS2xe85Z5AqPA
	LCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Lh+JrWDcWWDxSFGAQ5G
	JR7elZy/goVYE8uKK3MPMUpwMCuJ8LbzAYV4UxIrq1KL8uOLSnNSiw8xmgKDYCKzlGhyPjDl
	5JXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYFyUO/HXet/Jez0q
	LjWdCl/5wuSd6vw1brx/tWZyzhKZ4Jy465xfSkZEg3/rkRpmuZpHy3fMv3VG3Cz23eP6lptR
	h759nn4v+Y/FiTe9j6f+01x7K+Dsr/9dJz/Mf2QiH/vpgodxnl3qo/2HBF9eODhpT5m22epY
	3/B6H48bi1RWXbJ7/06X0XCVEktxRqKhFnNRcSIAtDF3GQEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew, 

On 08/23/2014 05:42 AM, Andrew Morton wrote:
> On Tue, 12 Aug 2014 11:01:07 +0900 y@samsung.com wrote:
> 
>> This patch define s3c_rtc structure including necessary variables for S3C RTC
>> device instead of global variables. This patch improves the readability by
>> removing global variables.
> 
> Below is the v1->v2 delta.
> 
> Why were all those tests of info->base added?  Can it really be zero? 
> I don't see how.

If some functions (e.g., s3c_rtc_settime) accesses the rtc register
by using info->base before the initialization of info->base in s3c_rtc_probe,
I thought that null pointer error would happen.

But, I missed one point which info->base might have the garbate data instead of NULL.
I'll add the initialization code for info->base.
	info->base = NULL;

If you don't agree it, I'll drop this code checking the state of info->base on next patchset(v3).

Best Regads,
Chanwoo Choi

> 
> --- a/drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2
> +++ a/drivers/rtc/rtc-s3c.c
> @@ -121,6 +121,9 @@ static int s3c_rtc_setaie(struct device
>  	struct s3c_rtc *info = dev_get_drvdata(dev);
>  	unsigned int tmp;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
>  
>  	clk_enable(info->rtc_clk);
> @@ -180,6 +183,9 @@ static int s3c_rtc_gettime(struct device
>  	struct s3c_rtc *info = dev_get_drvdata(dev);
>  	unsigned int have_retried = 0;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	clk_enable(info->rtc_clk);
>   retry_get_time:
>  	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
> @@ -224,6 +230,9 @@ static int s3c_rtc_settime(struct device
>  	struct s3c_rtc *info = dev_get_drvdata(dev);
>  	int year = tm->tm_year - 100;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
>  		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
>  		 tm->tm_hour, tm->tm_min, tm->tm_sec);
> @@ -255,6 +264,9 @@ static int s3c_rtc_getalarm(struct devic
>  	struct rtc_time *alm_tm = &alrm->time;
>  	unsigned int alm_en;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	clk_enable(info->rtc_clk);
>  	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
>  	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
> @@ -317,6 +329,9 @@ static int s3c_rtc_setalarm(struct devic
>  	struct rtc_time *tm = &alrm->time;
>  	unsigned int alrm_en;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	clk_enable(info->rtc_clk);
>  	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
>  		 alrm->enabled,
> @@ -357,6 +372,9 @@ static int s3c_rtc_proc(struct device *d
>  	struct s3c_rtc *info = dev_get_drvdata(dev);
>  	unsigned int ticnt;
>  
> +	if (!info->base)
> +		return -EINVAL;
> +
>  	clk_enable(info->rtc_clk);
>  	if (info->cpu_type == TYPE_S3C64XX) {
>  		ticnt = readw(info->base + S3C2410_RTCCON);
> @@ -548,7 +566,7 @@ static int s3c_rtc_probe(struct platform
>  		rtc_tm.tm_min	= 0;
>  		rtc_tm.tm_sec	= 0;
>  
> -		s3c_rtc_settime(NULL, &rtc_tm);
> +		s3c_rtc_settime(&pdev->dev, &rtc_tm);
>  
>  		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
>  	}
> _
> 
> 

