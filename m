Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3B1Jlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:41:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48960 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3B1Jll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:41:41 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-02-512f26542ff5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: Re: [PATCH 01/19] rtc: rtc-mv: remove erroneous __exit annotation
Date: Thu, 28 Feb 2013 18:41:39 +0900
Message-id: <000701ce1597$cf15a3f0$6d40ebd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAACGL1g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zfd0QNf1Ag2XnWS2WXLzKbjFn/Ro2
	i2e39jJZXF54idXi8q45bBb7OzsYHdg89kw8yeZxYsZvFo9DhzsYPfq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBm7Xu5nLbjMXfF7L2cD43rOLkZODgkBE4ktR86wQdhiEhfurQey
	uTiEBJYxSkyYc4ARpmhl11EmiMR0Rolda3sYIZxfjBKvLq4Ga2cTUJP48uUwexcjB4eIgL5E
	W4sGSA2zwB5GiR+971lA4kIC3BKrm4NAyjkFeCTW/elkBrGFBbwkNqzpYAWxWQRUJR6dWs0E
	YvMK2Er8+7uQDcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmkPESAuoSj/7qgoRFBIwkjjZv
	Y4YoEZHY9+Id2MkSAh/ZJdZemMcMsUtA4tvkQywQvbISmw4wQ/wrKXFwxQ2WCYwSs5BsnoVk
	8ywkm2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkjs9u1gvHnA+hBjMtD6icxS
	osn5wNjPK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGuLsCm/LPd9TI8Ae6dsybcjfQKZ83QNpjQvymtofx/zI059WY/uaTe8TY+t1gnrBh2Ib9
	dclqLc9SHDYl1urd4hH9csH3AOOsfdt9fZ3TO1W04hZemnI2QuNSHNu0iec+G2hWbz8h+WK7
	fOwVRsYXniHN+lyXhBZKm4plzD3Wvnj+LdeYXa+VWIozEg21mIuKEwH0XZSc8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQd0QNf1Ag/PZFksuXmW3mLN+DZvF
	s1t7mSwuL7zEanF51xw2i/2dHYwObB57Jp5k8zgx4zeLx6HDHYwefVtWMXpMn/eTyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBm7Xu5nLbjMXfF7L2cD43rO
	LkZODgkBE4mVXUeZIGwxiQv31rN1MXJxCAlMZ5TYtbaHEcL5xSjx6uJqNpAqNgE1iS9fDrN3
	MXJwiAjoS7S1aIDUMAvsYZT40fueBSQuJMAtsbo5CKScU4BHYt2fTmYQW1jAS2LDmg5WEJtF
	QFXi0anVYIt5BWwl/v1dyAZhC0r8mHyPBcRmFtCS2LytiRXClpfYvOYtM8h4CQF1iUd/dUHC
	IgJGEkebtzFDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQITgvPpHcwrmqwOMQowMGoxMPbYaIXKMSaWFZcmXuIUYKDWUmE14VfP1CINyWx
	siq1KD++qDQntfgQYzLQoxOZpUST84EpK68k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNIT
	S1KzU1MLUotgtjBxcEo1MC413jXf31a60smqydOyrHOOZvK26LZ1HuqbhL5LVMzos3q7gDvm
	6rfEhJREj6pPiyyc1dcfsPrK9PRNsMXha+H/PcwnOWXnPVAqL1Bv5Z8poDG3i7vif2ppmvQ6
	xz0yBW5OPEvOp7bMXtIsMrVPZnWBjXrURn7FSzpXT9QvC7Hkl7yswbZWiaU4I9FQi7moOBEA
	jxNCZU8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2013 5:38 PM, Jingoo Han wrote:
> 
> __init/__exit annotations for probe()/remove() are supposed to be
> __devinit/__devexit, because __init/__exit for probe()/remove()
> are not correct. However, __devinit/__devexit are not used,
> because CONFIG_HOTPLUG was removed. Thus, these annotations
> should be removed.
> 

Hi Andrew,

As Geert Uytterhoeven mentioned, the patchset is useless
because the drivers I sent for use platform_driver_probe().

Please, abandon all patchset that I sent.
Thank you.


Best regards,
Jingoo Han


> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-mv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
> index 57233c8..8cb15d2 100644
> --- a/drivers/rtc/rtc-mv.c
> +++ b/drivers/rtc/rtc-mv.c
> @@ -284,7 +284,7 @@ static int mv_rtc_probe(struct platform_device *pdev)
>  	return 0;
>  }
> 
> -static int __exit mv_rtc_remove(struct platform_device *pdev)
> +static int mv_rtc_remove(struct platform_device *pdev)
>  {
>  	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
> 
> @@ -303,7 +303,7 @@ static struct of_device_id rtc_mv_of_match_table[] = {
>  #endif
> 
>  static struct platform_driver mv_rtc_driver = {
> -	.remove		= __exit_p(mv_rtc_remove),
> +	.remove		= mv_rtc_remove,
>  	.driver		= {
>  		.name	= "rtc-mv",
>  		.owner	= THIS_MODULE,
> --
> 1.7.2.5


