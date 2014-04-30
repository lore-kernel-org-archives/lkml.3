Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaD3A6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:58:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50685 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaD3A6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:58:43 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-6e-53604ac1ee8b
Message-id: <53604AC0.6020306@samsung.com>
Date: Wed, 30 Apr 2014 09:58:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, rafael.j.wysocki@intel.com,
        Nishanth Menon <nm@ti.com>, Jiri Kosina <jkosina@suse.cz>,
        labbe.montjoie@gmail.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 5/5] devfreq: exynos5: Use devm_devfreq_* function using
 device resource management
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
 <1398416894-6782-6-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHyP63QaaBwc4vkkqU4g3+B2DpqeC_11E5+LevWXED0Qxg@mail.gmail.com>
In-reply-to: <CAK9yfHyP63QaaBwc4vkkqU4g3+B2DpqeC_11E5+LevWXED0Qxg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkUPegV0KwQecrIYvHaxYzWWycsZ7V
	Yt7Et+wWu+csZrHoXXCVzeJs0xt2i/ULFrJZbHp8jdXi8q45bBafe48wWsw4v4/J4nbjCjaL
	Nz/OMlk8XgHUdvJPL6MDv8fOWXfZPRbvecnkcefaHjaPzUvqPfq2rGL0OLPgCLvH8RvbmTw+
	b5IL4IjisklJzcksSy3St0vgyvgyv52x4JF0xbqb/awNjJ9Fuhg5OSQETCT2LfrFCmGLSVy4
	t54NxBYSWMooMbcvF6Zm1+ZXjF2MXEDxRYwSO840MUE4rxklpjR8ZQKp4hXQklg+8ycziM0i
	oCox68AnsElsQPH9L26A2aICYRIrp19hgagXlPgx+R6YLQJU87J7OdhQZoEbLBL3n01kB0kI
	C2RKPL58lw1i2zFGiea1S4CqODg4BYIl1hzxA6lhFlCXmDRvETOELS+xec1bZpB6CYGFHBJ/
	vx5hgbhIQOLb5EMsIL0SArISmw4wQ7wmKXFwxQ2WCYxis5DcNAvJ2FlIxi5gZF7FKJpakFxQ
	nJReZKJXnJhbXJqXrpecn7uJERjlp/89m7CD8d4B60OMyUArJzJLiSbnA5NEXkm8obGZkYWp
	iamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwZs22vOrz99f6JVN+
	Hln6LTuHf7XekRWLorb3TfSsu9Ik0BrjIlf+NdDEO0yCPX3bhENrLyZrTGIJWvbswwedztPH
	eoSanRev6OEQOtJ99ujKvsCi5143GcwUdM4e+CmW6LfgVX7xmVvJnX5CvbNj+sK2BCff3bE3
	PyqpaaGE7NPooK2P2O/kKLEUZyQaajEXFScCAEkZUEAIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jAd2DXgnBBov6OS0er1nMZLFxxnpW
	i3kT37Jb7J6zmMWid8FVNouzTW/YLdYvWMhmsenxNVaLy7vmsFl87j3CaDHj/D4mi9uNK9gs
	3vw4y2TxeAVQ28k/vYwO/B47Z91l91i85yWTx51re9g8Ni+p9+jbsorR48yCI+wex29sZ/L4
	vEkugCOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGl/ntjAWPpCvW3exn
	bWD8LNLFyMkhIWAisWvzK0YIW0ziwr31bF2MXBxCAosYJXacaWKCcF4zSkxp+MoEUsUroCWx
	fOZPZhCbRUBVYtaBT2wgNhtQfP+LG2C2qECYxMrpV1gg6gUlfky+B2aLANW87F4ONpRZ4AaL
	xP1nE9lBEsICmRKPL9+FWn2MUaJ57RKgKg4OToFgiTVH/EBqmAXUJSbNW8QMYctLbF7zlnkC
	o8AsJDtmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgJPJMegfjqgaLQ4wC
	HIxKPLwCW+ODhVgTy4orcw8xSnAwK4nwzmFJCBbiTUmsrEotyo8vKs1JLT7EmAwMgonMUqLJ
	+cAEl1cSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjNm2H+LO
	XDH4FfN/kja3poSQ1mrd6jwDpYU32ORmnZR56B5zd4NUwKyVP95yXF0Rv3dee97LQlXp/rru
	gqf/3O0XZ8zIvGxk3/DkmOlDB54jH9/uYEnRvy8/z0zh6FmhnXfXfjqnfCW5PfXs3lc3Hr33
	auF2ijy1zNPMe9I0G97uV8WfTv9c2qjEUpyRaKjFXFScCAADSLEFZgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/30/2014 01:54 AM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 25 April 2014 14:38, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch uses devm_devfreq_add_device()/devm_devfreq_register_opp_notifier()
>> to control automatically the resource of devfreq.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Cc: Manish Badarkhe <badarkhe.manish@gmail.com>
>> Cc: Abhilash Kesavan <a.kesavan@samsung.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-samsung-soc@vger.kernel.org
>> ---
>>  drivers/devfreq/exynos/exynos5_bus.c | 23 ++++++++---------------
>>  1 file changed, 8 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
>> index ab54a69..1f622f8 100644
>> --- a/drivers/devfreq/exynos/exynos5_bus.c
>> +++ b/drivers/devfreq/exynos/exynos5_bus.c
>> @@ -165,11 +165,6 @@ static int exynos5_int_get_dev_status(struct device *dev,
>>  }
>>  static void exynos5_int_exit(struct device *dev)
>>  {
>> -       struct platform_device *pdev = container_of(dev, struct platform_device,
>> -                                                   dev);
>> -       struct busfreq_data_int *data = platform_get_drvdata(pdev);
>> -
>> -       devfreq_unregister_opp_notifier(dev, data->devfreq);
>>  }
> 
> Do you need an empty function?

exynos5_init_exit() function would be removed because this function is not necessary.

> 
>>
>>  static struct devfreq_dev_profile exynos5_devfreq_int_profile = {
>> @@ -343,30 +338,29 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
>>
>>         busfreq_mon_reset(ppmu_data);
>>
>> -       data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
>> +       data->devfreq = devm_devfreq_add_device(dev, &exynos5_devfreq_int_profile,
>>                                            "simple_ondemand", NULL);
>> -
>>         if (IS_ERR(data->devfreq)) {
>>                 err = PTR_ERR(data->devfreq);
> 
> No need of err.   return PTR_ERR(data->devfreq);

OK, I'll fix it.

> 
>> -               goto err_devfreq_add;
>> +               return err;
>>         }
>>
>> -       devfreq_register_opp_notifier(dev, data->devfreq);
>> +       err = devm_devfreq_register_opp_notifier(dev, data->devfreq);
>> +       if (err < 0) {
>> +               dev_err(dev, "Failed to register opp notifier\n");
>> +               return err;
>> +       }
>>
>>         err = register_pm_notifier(&data->pm_notifier);
>>         if (err) {
>>                 dev_err(dev, "Failed to setup pm notifier\n");
>> -               goto err_devfreq_add;
>> +               return err;
>>         }
>>
>>         /* TODO: Add a new QOS class for int/mif bus */
>>         pm_qos_add_request(&data->int_req, PM_QOS_NETWORK_THROUGHPUT, -1);
>>
>>         return 0;
>> -
>> -err_devfreq_add:
>> -       devfreq_remove_device(data->devfreq);
>> -       return err;
>>  }
>>
>>  static int exynos5_busfreq_int_remove(struct platform_device *pdev)
>> @@ -375,7 +369,6 @@ static int exynos5_busfreq_int_remove(struct platform_device *pdev)
>>
>>         pm_qos_remove_request(&data->int_req);
>>         unregister_pm_notifier(&data->pm_notifier);
>> -       devfreq_remove_device(data->devfreq);
>>
>>         return 0;
>>  }
>> --
>> 1.8.0
>>
> 
> 
> 

