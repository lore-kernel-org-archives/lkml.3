Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3CUCQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:16:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43813 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3CUCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:16:21 -0400
X-AuditID: cbfee68e-b7f946d000001e37-71-514a6d74eece
Date: Thu, 21 Mar 2013 02:16:20 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] drivers/rtc/rtc-tegra.c: fix build warning
To: ldewangan@nvidia.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, rtc-linux@googlegroups.com,
        "jg1.han@samsung.com" <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130321021508552@jg1.han
Msgkey: 20130321021508552@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130321021508552@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12992973.303791363832178703.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zA92SXK9Agx0PZSwu75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJm/Hx0h7XggUhFw6sfzA2MM0S6GDk5hASUJCad3MsIYksImEicuvSM
	DcIWk7hwbz2QzQVUs4xR4sHv22wwRU0HnrJCJOYzSlzevRoswSKgKjHhwjV2EJtNQF1iwu9m
	li5GDg5hAXuJtWdrQcIiArISH79vAOtlFtjGKHF1wXNWiCtkJe5Nns0MYvMKCEqcnPmEBWKZ
	gkTzxp1sEHFFiad7DjNDxCUk7tzfzwph80rMaH8KVS8nMe3rGqgaaYnzszYwwnyz+PtjqDi/
	xLHbO5hAbgPpfXI/GGbM7s1foH4UkJh65iAjRImqxNFDERBhPok1C99CbRKUOH2tmxmmtWHj
	b7DPmYGunNL9EMrWkvjyYx8buq94BZwk/t8/zjqBUXkWktQsJO2zkLQjq1nAyLKKUTS1ILmg
	OCm9yAg5sjcxQtJg3w7GmwesDzHuZwRGyURmKdHkfGAizSuJNzQ2M7IwNTE1NjK3NKNQ2MTU
	wsLEiCrCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY5+wVSz3OKvV2mYHU4aXT
	mF8e0JlfGmi3xr9BienlqQlhlsfbp1t3rHR+M1luU9jlzecLO/fbFbl/asv3m/bMsEljobPz
	9gJLP58YG/f7VRef21ZFzKya/8/h5sGvyptrpiz3fHBJ4sLnSQIuiat2OnKuOrRm/4L3nuqN
	/ImMwodzlIxr34qJKrEUZyQaajEXFScCALGz8UL2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dN2SXK9AgyfreSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6xZayVoYGBkSlQVUJG
	xs9Hd1gLHohUNLz6wdzAOEOki5GTQ0hASWLSyb2MILaEgIlE04GnrBC2mMSFe+vZuhi5gGrm
	M0pc3r2aDSTBIqAqMeHCNXYQm01AXWLC72aWLkYODmEBe4m1Z2tBwiICshIfv29gBellFtjG
	KHF1wXNWiGWyEvcmz2YGsXkFBCVOznzCArFMQaJ54042iLiixNM9h5kh4hISd+7vhzqIV2JG
	+1OoejmJaV/XQNVIS5yftYER5ujF3x9Dxfkljt3ewQRyG0jvk/vBMGN2b/7CBmELSEw9c5AR
	okRV4uihCIgwn8SahW+hNglKnL7WzQzT2rDxN9jnzEBXTul+CGVrSXz5sY8N3Ve8Ak4S/+8f
	Z53AKDcLSWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYahXnJhbXJqXrpecn7uJEZygni3cwfjl
	vPUhRgEORiUeXo4nnoFCrIllxZW5hxglOJiVRHiXKXkFCvGmJFZWpRblxxeV5qQWH2JMBsbf
	RGYp0eR8YPLMK4k3NDY2MTMxNTewMLA0J01YSZz3aat1oJBAemJJanZqakFqEcwWJg5OqQZG
	+fVVbyedec61PvG91KF8xsY9DjPm2vPkXF069yGv4buqZXWqzdfyljJYbbep2N36cqVMyMRN
	pvf8rXuE4p4df+rWL2D+O9r6FsO0xcy/d9q3J4akrdxTamTUmCA0qVZnnffnNp+exLgFd63K
	MlvnSy7nsxD0Mz5e8C3gj/U79osuM/bVeh5TYinOSDTUYi4qTgQA1L3bqZQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2L2GN3G003749

On Wed, 20 Mar 2013 05:30:25 -0700, Laxman Dewangan wrote:
>
> Fix the below build warning:
>
> drivers/rtc/rtc-tegra.c: In function 'tegra_rtc_probe':
> drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 1 of 
> 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
> include/linux/rtc.h:136:27: note: expected 'struct device *' but argument is of 
> type 'const char *'
> drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 2 of 
> 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
> include/linux/rtc.h:136:27: note: expected 'const char *' but argument is of 
> type 'struct device *'
> This warning was introduced with patch
>         commit 8a96d445e921b0d881421767fb6f7c5b6fb91b3a
>         drivers/rtc/rtc-tegra.c: use managed rtc_device_register()
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

It looks good.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/rtc/rtc-tegra.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
> index 7cb3da0..a34315d 100644
> --- a/drivers/rtc/rtc-tegra.c
> +++ b/drivers/rtc/rtc-tegra.c
> @@ -349,8 +349,9 @@ static int __init tegra_rtc_probe(struct platform_device 
> *pdev)
>  
>         device_init_wakeup(&pdev->dev, 1);
>  
> -       info->rtc_dev = devm_rtc_device_register(dev_name(&pdev->dev),
> -                               &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
> +       info->rtc_dev = devm_rtc_device_register(&pdev->dev,
> +                               dev_name(&pdev->dev), &tegra_rtc_ops,
> +                               THIS_MODULE);
>         if (IS_ERR(info->rtc_dev)) {
>                 ret = PTR_ERR(info->rtc_dev);
>                 dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
> -- 
> 1.7.1.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
