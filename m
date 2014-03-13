Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaCMCQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:16:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaCMCQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:16:20 -0400
Date: Thu, 13 Mar 2014 11:16:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 1/4] devfreq: exynos4: Support devicetree to get device id
 of Exynos4 SoC
In-reply-to: <1794344.yC40yetU2h@amdc1032>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <532114F2.7050405@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-AuditID: cbfee68d-b7fcd6d00000315b-48-532114f2afc7
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQPeTiGKwwfIeM4uNM9azWpxtesNu
	0f0j2+LyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yO3B4LN7zksmjb8sqRo/jN7YzeXzeJBfA
	EsVlk5Kak1mWWqRvl8CV0fNpP2PBZ5GKT8v2sTUwzhbsYuTkkBAwkTh59xULhC0mceHeerYu
	Ri4OIYGljBInXrcxwRQt3LmTFSIxnVHiyr/jTBDOK0aJBxsfMnYxcnDwCmhJ/OgpB2lgEVCV
	uL16LRuIzQYU3v/iBpgtKhAmsXL6FbBtvAKCEj8m3wOzRQQsJNaueMsCMpNZYA+jxNS+X6wg
	CWGBeIlV6x6zQyybzyjRt3wRI0iCE2jqs4bPYOcxC+hI7G+dxgZhy0tsXvOWGaRBQuASu8SV
	xv1sECcJSHybfIgF5FIJAVmJTQeYIV6TlDi44gbLBEaxWUiOmoVk7CwkYxcwMq9iFE0tSC4o
	TkovMtQrTswtLs1L10vOz93ECIy80/+e9e5gvH3A+hBjMtDKicxSosn5wMjNK4k3NDYzsjA1
	MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGa/5CrwViDIxnrd3F
	fnfrHGEbxeKF/57rTc1R/GQbFRvUqfi6+23PgcOLeuexVjO9zZTWm/Mx1Ch3qduUx3daDxdv
	iZ75wORobp2nZtQUFg7X9wWBp6VC6mZdetC/euPWA7t3JbXePXDd8Gza1vK6zPVJO65W7ahM
	/ydRcazZt+VmSfKE5xGtSizFGYmGWsxFxYkADGc29tICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd1PIorBBr/+6FpsnLGe1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	lqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBk9n/YzFnwWqfi0bB9bA+Ns
	wS5GTg4JAROJhTt3skLYYhIX7q1n62Lk4hASmM4oceXfcSYI5xWjxIONDxm7GDk4eAW0JH70
	lIM0sAioStxevZYNxGYDCu9/cQPMFhUIk1g5/QoLiM0rICjxY/I9MFtEwEJi7Yq3LCAzmQX2
	MEpM7fsFtllYIF5i1brH7BDL5jNK9C1fxAiS4ASa+qzhMxOIzSygI7G/dRobhC0vsXnNW+YJ
	jAKzkCyZhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/qZ9A7GVQ0WhxgF
	OBiVeHhXLFcIFmJNLCuuzD3EKMHBrCTC27UGKMSbklhZlVqUH19UmpNafIgxGRgGE5mlRJPz
	gSknryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYJ0ZI3Mo3
	eMTpL28XMiXu2xfZYrZdy3i+NxXV+sQcvf9ZfpnhvVcVsn483774/eEoMjKz/21/ZPmazPsF
	dzzalvD6XOPiU1PM6meedLuqeE5O/rTTZ7/8SNpy3+Z28o09pw4fcD9jwLNx3S3/mLIMCdP1
	Ydy+NZfn7Uy3Oeb/ZOa63twdMmHtSizFGYmGWsxFxYkAIgF0zS8DAAA=
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-2-git-send-email-cw00.choi@samsung.com>
 <1794344.yC40yetU2h@amdc1032>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Batlomiej,

On 03/12/2014 11:37 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Chanwoo,
> 
> On Wednesday, March 12, 2014 08:47:59 PM Chanwoo Choi wrote:
>> This patch support DT(DeviceTree) method to probe exynos4_bus and get device
>> id of each Exynos4 SoC by using dt helper function.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>> index e07b0c6..168a7c6 100644
>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/devfreq.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/regulator/consumer.h>
>> +#include <linux/of.h>
>>  #include <linux/module.h>
>>  
>>  /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
>> @@ -1017,6 +1018,28 @@ unlock:
>>  	return NOTIFY_DONE;
>>  }
>>  
>> +static struct of_device_id exynos4_busfreq_id_match[] = {
>> +	{
>> +		.compatible = "samsung,exynos4210-busfreq",
>> +		.data = (void *)TYPE_BUSF_EXYNOS4210,
>> +	}, {
>> +		.compatible = "samsung,exynos4x12-busfreq",
>> +		.data = (void *)TYPE_BUSF_EXYNOS4x12,
>> +	},
>> +};
>> +
>> +static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	const struct of_device_id *match;
>> +
>> +	match = of_match_node(exynos4_busfreq_id_match, dev->of_node);
>> +	if (!match)
>> +		return -ENODEV;
>> +
>> +	return (int) match->data;
>> +}
>> +
>>  static int exynos4_busfreq_probe(struct platform_device *pdev)
>>  {
>>  	struct busfreq_data *data;
>> @@ -1030,7 +1053,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  	}
>>  
>> -	data->type = pdev->id_entry->driver_data;
>> +	data->type = exynos4_busfreq_get_driver_data(pdev);
>>  	data->dmc[0].hw_base = S5P_VA_DMC0;
>>  	data->dmc[1].hw_base = S5P_VA_DMC1;
>>  	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
>> @@ -1135,6 +1158,7 @@ static struct platform_driver exynos4_busfreq_driver = {
>>  		.name	= "exynos4-busfreq",
>>  		.owner	= THIS_MODULE,
>>  		.pm	= &exynos4_busfreq_pm,
>> +		.of_match_table = exynos4_busfreq_id_match,
>>  	},
>>  };
> 
> It looks OK but it would be good to also add bindings documentation file,
> i.e. Documentation/devicetree/bindings/devfreq/exynos4_bus.txt.

OK I'll add documentation for exynos4_bus.c

Best Regards,
Chanwoo Choi

