Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3EPByO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:54:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60402 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3EPByM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:54:12 -0400
X-AuditID: cbfee691-b7fef6d000002d62-b0-51943c4397ce
Date: Thu, 16 May 2013 01:54:11 +0000 (GMT)
From: =?euc-kr?B?x9HB+LG4?= <jg1.han@samsung.com>
Subject: Re: [PATCH] rtc: max8998: Check for pdata presence before dereferencing
To: Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        akpm@linux-foundation.org
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        =?euc-kr?Q?=BD=C9=C1=D8=BF=B5?= <jy0922.shim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516015006711@jg1.han
Msgkey: 20130516015006711@jg1.han
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516015006711@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17870889.122861368669248723.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJsWRmVeSWpSXmKPExsVy+t8zY11nmymBBsfWq1lc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMOHbsFWPBPP6K9s8sDYwv+LoYOTmEBJQkJp3cywhiSwiYSNzdf4YF
	whaTuHBvPVsXIxdQzTJGiaeXVrPBFH170wSVmM8o8bHrGitIgkVAVaJ98Sp2EJtNwEhiZfMp
	ZhBbWCBAYsb/+6wgDSICkxklbv1aBeYwCzQwS1z4+JEJ4g5ZiXuTZ4N18AoISpyc+QTqDgWJ
	O0sXsUHEFSV+nNkMdauExKzpF1ghbF6JGe1PoerlJKZ9XcMMYUtLnJ+1gRHmn8XfH0PF+SWO
	3d4BtJcDrPfJ/WCYMbs3f4H6UkBi6pmDUK2qEm/fzoZaxSexZuFbqFWCEqevdTPD9N7fMhfs
	FWagM6d0P2SHsLUkvvzYx4buLV4BJ4knWy6wTWBUnoUkNQtJ+ywk7chqFjCyrGIUTS1ILihO
	Si8yRY7uTYyQVDhxB+P9A9aHGPczAmNlIrOUaHI+MJnmlcQbGpsZWZiamBobmVuaUShsYmph
	YWJEFWElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYy6tRt6am7ImKW2M3jpvfbe
	vdKN+/PF8NSzOqufGwhbJE+U7Ba73Ppw/aknet4379SfXcguN//4dc9bS/JYm571HZeaUa5U
	L+YcW2FqvVh9j2JLrMih25HnxT9lbo50+u/pmvP1xG5/g0e7P9txVJ6+3htx9uDvvbu91Jew
	82+KtEu0uLnaIk2JpTgj0VCLuag4EQCBNUxE+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/2dF1nmymBBm9+i1lc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jGPHXjEWzOOvaP/M0sD4gq+LkZNDSEBJYtLJvYwgtoSAicS3N01sELaYxIV764FsLqCa+YwS
	H7uusYIkWARUJdoXr2IHsdkEjCRWNp9iBrGFBQIkZvy/zwrSICIwmVHi1q9VYA6zQAOzxIWP
	H5kg1slK3Js8G6yDV0BQ4uTMJywQ6xQk7ixdxAYRV5T4cWYz1EkSErOmX2CFsHklZrQ/haqX
	k5j2dQ0zhC0tcX7WBkaYsxd/fwwV55c4dnsH0F4OsN4n94Nhxuze/AXqSwGJqWcOQrWqSrx9
	OxtqFZ/EmoVvoVYJSpy+1s0M03t/y1ywV5iBzpzS/ZAdwtaS+PJjHxu6t3gFnCSebLnANoFR
	bhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4Kb3CUK84Mbe4NC9dLzk/dxMjOEk9W7iD8ct560OM
	AhyMSjy8LwynBAqxJpYVV+YeYpTgYFYS4f1kABTiTUmsrEotyo8vKs1JLT7EmAyMwonMUqLJ
	+cAEmlcSb2hsbGJmYmpuYGFgaU6asJI479NW60AhgfTEktTs1NSC1CKYLUwcnFINjNHMdyoN
	nngsLP+XePO/db2F+SFfW4cfLAu/ftjb+enej6uHLWp2PYjU3Tn5zbaGIPvzj0/vv2Awa9NL
	zqQHXRLPV+4K1HVzYOZhs0ivktu+NvnEBS8R+0QfmZcV1T5uqrm3Wh7uVtS4s0HUe5K/2oqW
	jjWi9T8n/tKZ/+/Cue27Z/PfC1NfvE+JpTgj0VCLuag4EQDiM9AjlgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G1sIMo018927

Thursday, May 16, 2013 12:16 AM, Tomasz Figa wrote:
> 
> Currently the driver can crash with a NULL pointer dereference if no pdata
> is provided, despite of successful registration of MFD part. This patch
> fixes the problem by adding a NULL check before dereferencing the pdata
> pointer.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

CC'ed Andrew Morton

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/rtc/rtc-max8998.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
> index 48b6612..d5af7ba 100644
> --- a/drivers/rtc/rtc-max8998.c
> +++ b/drivers/rtc/rtc-max8998.c
> @@ -285,7 +285,7 @@ static int max8998_rtc_probe(struct platform_device *pdev)
>  			info->irq, ret);
> 
>  	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
> -	if (pdata->rtc_delay) {
> +	if (pdata && pdata->rtc_delay) {
>  		info->lp3974_bug_workaround = true;
>  		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
>  				" RTC updates will be extremely slow.\n");
> --
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
