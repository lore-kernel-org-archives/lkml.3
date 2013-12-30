Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3L3BcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 20:32:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17862 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3L3Bb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 20:31:58 -0500
X-AuditID: cbfee690-b7f266d00000287c-c5-52c0cd0d7dd1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Zhang Rui'" <rui.zhang@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        "'Eduardo Valentin'" <eduardo.valentin@ti.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>,
        "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Lukasz Majewski'" <l.majewski@samsung.com>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388357260-4843-24-git-send-email-Julia.Lawall@lip6.fr>
In-reply-to: <1388357260-4843-24-git-send-email-Julia.Lawall@lip6.fr>
Subject: Re: [PATCH 23/25] thermal: exynos: fix error return code
Date: Mon, 30 Dec 2013 10:31:57 +0900
Message-id: <000001cf04fe$edccf3f0$c966dbd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8E4Fo6ZT3/d0WkRE2N5bwaEWSi0AAHfWMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zA13esweCDBZs1LVouBpisWb/TyaL
	ywsvsVp0nn3CbLHswWlGi623pC16F1xls3jzcDOjxabH11gtLu+aw2bxufcIo8WM8/uYLJ48
	7GNz4PVYvOclk8feLVkem5fUe/RtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDI61+9l
	KbjIVXGiz7CBcS5HFyMnh4SAicTSxpPMELaYxIV769m6GLk4hASWMUpMu9nA2sXIAVa081kW
	RHw6o8TPbYfZIZxfjBJv375nA+lmE1CT+PIFJMHJISLgI/H29kpWkCJmgY3MEr9uvmUBSQgJ
	1Ek0LHsPVsQp4Crx/t9TJpANwgKOEt/XSoKEWQRUJRaffg02k1fAVmLF7TcsELagxI/J98Bs
	ZgEtifU7jzNB2PISm9e8ZYY4VF3i0V9diBOMJP6tvwJVLiKx78U7RpBzJATmckj0XLrCBLFL
	QOLb5EMsEL2yEpsOQANCUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IhO9
	4sTc4tK8dL3k/NxNjJDIn7CD8d4B60OMyUDrJzJLiSbnAxNHXkm8obGZkYWpiamxkbmlGWnC
	SuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwst6c+cRsvU2vidMUu4Lckkm8d8V/
	OWx5t3HrunuBa4Vj/hy0smdt+sH+avLEj8vCrKUcv2X5GT6U3uz84uglzdC98sKZk525Gd0f
	VZ1ecGtyhsyDZ3tNYw6VOCfN2mR+0XhNO4NZ88fta9ls7qjd6e5mvCBVGvrTNn66uyObZOi0
	0vdrrq3SU2Ipzkg01GIuKk4EALDgPLQSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQV3esweCDCZ+VbdouBpisWb/TyaL
	ywsvsVp0nn3CbLHswWlGi623pC16F1xls3jzcDOjxabH11gtLu+aw2bxufcIo8WM8/uYLJ48
	7GNz4PVYvOclk8feLVkem5fUe/RtWcXocfzGdiaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nbYZoQGuKm
	awHTGKHrGxIE12NkgAYS1jFmdK7fy1JwkaviRJ9hA+Ncji5GDg4JAROJnc+yuhg5gUwxiQv3
	1rN1MXJxCAlMZ5T4ue0wO4Tzi1Hi7dv3bCBVbAJqEl++gCQ4OUQEfCTe3l7JClLELLCRWeLX
	zbcsIAkhgTqJhmXvwYo4BVwl3v97ygSyTVjAUeL7WkmQMIuAqsTi06/BZvIK2EqsuP2GBcIW
	lPgx+R6YzSygJbF+53EmCFteYvOat8wQR6tLPPqrC3GCkcS/9VegykUk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Vn0jsYVzVYHGIU4GBU
	4uF9GbA/SIg1say4MvcQowQHs5IIr9vpA0FCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9M
	eXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMgsMeNXkbvV
	YXmzhPPsH5uYDx7LfJZnMdtD44vMJyZu+9z5P7Xfp342zjhw3FP0xx3j761GR1JObY46E/bi
	6f29r6MkNLN6XjXxG+5KcDm41raqkJlLunLFwwCj55NlfzRO3JnFsvXozueHXir3Pt8ZYaii
	8DJy86WXvYdn/+dpzql/x7LZ4aMSS3FGoqEWc1FxIgC96mVfbwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 30, 2013 7:48 AM, Julia Lawall wrote:
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to an error code as done elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

(+cc Amit Daniel Kachhap, Jonghwa Lee)

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> ---
> Not tested.
> 
>  drivers/thermal/samsung/exynos_tmu.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 32f38b9..0d96a51 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -205,6 +205,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  skip_calib_data:
>  	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>  		dev_err(&pdev->dev, "Invalid max trigger level\n");
> +		ret = -EINVAL;
>  		goto out;
>  	}
> 
> 
> --

