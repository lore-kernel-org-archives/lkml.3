Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaCQFFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:05:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32346 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaCQFFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:05:44 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-7e-532682a6e494
Message-id: <532682A8.2030300@samsung.com>
Date: Mon, 17 Mar 2014 14:05:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 4/8] devfreq: exynos4: Fix bug of resource leak and code
 clean on probe()
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-5-git-send-email-cw00.choi@samsung.com>
 <53234132.8080202@samsung.com>
In-reply-to: <53234132.8080202@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkQHd5k1qwwTRji46e3ywW84+cY7U4
	92olo8XZpjfsFgvblrBYXN41h83ic+8RRosZ5/cxWSy9fpHJ4nbjCjaLNz/OMllMmL6WxeLx
	irfsFq8OtrFYrJ/xmsWB32PNvDWMHiuXf2HzWLznJZPHz+Xb2T36tqxi9Dh+YzuTx+dNch4b
	54YGcERx2aSk5mSWpRbp2yVwZSzs2sJe8EKhYu6Gy2wNjJcluxg5OSQETCQun5/HCGGLSVy4
	t56ti5GLQ0hgKaPEi9MTWWCK/j/azQKRmM4osebAVlaQhJDAK0aJ3kXSIDavgJbExLdf2UFs
	FgFViY39a8Ga2YDi+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbREBF4vKp6WBXMAt8ZZK4OY8J
	xBYWSJQ4tnsa1OJFjBIX9n0GG8QpoC2xZmonC0SDjsT+1mlsELa8xOY1b5lBGiQE5nJIHLz/
	mhXiIgGJb5MPATVwACVkJTYdYIb4TFLi4IobLBMYxWYhuWkWkrGzkIxdwMi8ilE0tSC5oDgp
	vchQrzgxt7g0L10vOT93EyMwxk//e9a7g/H2AetDjMlAKycyS4km5wNTRF5JvKGxmZGFqYmp
	sZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MG52CXT7wL9WPPbC6+mW
	M695NlsfFK/a4Vv9gLt8avmhmy7t3zde+i9VOZ1DmIH/VmpGeKXravmeKNOp0uaz1lVcORCc
	n39043mnLgbW3/x3J8++ILjuEPuq23Y//p6zCdkuonvhgP8/9wviiy1aH39nFz1goiRb1Xvo
	7S119xnXxYzrJx46EKDEUpyRaKjFXFScCACh5VPkBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQd1lTWrBBqdPG1t09PxmsZh/5Byr
	xblXKxktzja9YbdY2LaExeLyrjlsFp97jzBazDi/j8li6fWLTBa3G1ewWbz5cZbJYsL0tSwW
	j1e8Zbd4dbCNxWL9jNcsDvwea+atYfRYufwLm8fiPS+ZPH4u387u0bdlFaPH8RvbmTw+b5Lz
	2Dg3NIAjqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNct
	MwfoeiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsKuLewFLxQq5m64
	zNbAeFmyi5GTQ0LAROL/o90sELaYxIV769m6GLk4hASmM0qsObCVFSQhJPCKUaJ3kTSIzSug
	JTHx7Vd2EJtFQFViY/9asGY2oPj+FzfYQGxRgTCJldOvsEDUC0r8mHwPzBYRUJG4fGo6I4jN
	LPCVSeLmPCYQW1ggUeLY7mksEIsXMUpc2PcZbBCngLbEmqmdLBANOhL7W6exQdjyEpvXvGWe
	wCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOIU8k9rBuLLB4hCj
	AAejEg/vBGW1YCHWxLLiytxDjBIczEoivHqxQCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqc
	D0xveSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6JDNaiVU
	4G757Fni7n+ZqbxiH4LWSf/t2fex/d7ElF1J83btL7mYuu6oeqECf3XpBQmviZ7/686H3vM8
	da3ospTA7wIl9xnZ739olO4oLNf561sivCu9oGnV9f3KbH9FC/WrDu8qOZHExXR2MetBgxJD
	1X3v9rqsOnZq06HmWi0p/38HN3efV2Ipzkg01GIuKk4EAHZfNVllAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/15/2014 02:49 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 13.03.2014 09:17, Chanwoo Choi wrote:
>> This patch fix bug about resource leak when happening probe fail and code clean
>> to add debug message.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   drivers/devfreq/exynos/exynos4_bus.c | 32 ++++++++++++++++++++++++++------
>>   1 file changed, 26 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>> index a2a3a47..152a3e9 100644
>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>> @@ -1152,8 +1152,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>           dev_err(dev, "Cannot determine the device id %d\n", data->type);
>>           err = -EINVAL;
>>       }
>> -    if (err)
>> +    if (err) {
>> +        dev_err(dev, "Cannot initialize busfreq table %d\n",
>> +                 data->type);
>>           return err;
>> +    }
>>
>>       rcu_read_lock();
>>       opp = dev_pm_opp_find_freq_floor(dev,
>> @@ -1176,7 +1179,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>       if (IS_ERR(data->devfreq)) {
>>           dev_err(dev, "Failed to add devfreq device\n");
>>           err = PTR_ERR(data->devfreq);
>> -        goto err_opp;
>> +        goto err_devfreq;
>>       }
>>
>>       /*
>> @@ -1185,18 +1188,35 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>        */
>>       busfreq_mon_reset(data);
>>
>> -    devfreq_register_opp_notifier(dev, data->devfreq);
>> +    /* Register opp_notifier for Exynos4 busfreq */
>> +    err = devfreq_register_opp_notifier(dev, data->devfreq);
>> +    if (err < 0) {
>> +        dev_err(dev, "Failed to register opp notifier\n");
>> +        goto err_notifier_opp;
>> +    }
>>
>> +    /* Register pm_notifier for Exynos4 busfreq */
>>       err = register_pm_notifier(&data->pm_notifier);
>>       if (err) {
>>           dev_err(dev, "Failed to setup pm notifier\n");
>> -        devfreq_remove_device(data->devfreq);
>> -        return err;
>> +        goto err_notifier_pm;
>>       }
>>
>>       return 0;
>>
>> -err_opp:
>> +err_notifier_pm:
>> +    devfreq_unregister_opp_notifier(dev, data->devfreq);
>> +err_notifier_opp:
>> +    /*
>> +     * The devfreq_remove_device() would execute finally devfreq->profile
>> +     * ->exit(). To avoid duplicate resource free operation, return directly
>> +     * before executing resource free below 'err_devfreq' goto statement.
>> +     */
> 
> I'm not quite sure about this. I believe that in this case devfreq->profile->exit() would be exynos4_bus_exit() and all it does is devfreq_unregister_opp_notifier(dev, data->devfreq), so all remaining resources (regulators, clocks, etc.) would get leaked.

This patch execute following sequence to probe exynos4_busfreq.c:

1. Parse dt node to get resource(regulator/clock/memory address).
2. Enable regulator/clock and map memory.
3. Add devfreq device using devfreq_add_device().
   The devfreq_add_device() return devfreq instance(data->devfreq).
4. Register opp_notifier using devfreq instance(data->devfreq) which is created in sequence #3.

Case 1,
If an error happens in sequence #3 for registering devfreq_add_device(),

this case can't execute devfreq->profile->exit() to free resource
because this case has failed to register devfreq->profile to devfreq_list.

So, must goto 'err_devfreq' statement to free resource(regulator/clock/memory).


Case 2,
If an error happens in sequence #4 for registering opp_notifier,

In contrast
this case can execute devfreq->profile->exit() to free resource.
But, After executed devfreq->profile->exit(),
should not execute 'err_devfreq' statement to free resource.
In case, will operate twice of resource.

If my explanation is wrong, please reply your comment.

> 
> I believe the correct thing to do would be to remove the .exit() callback from exynos4_devfreq_profile struct and handle all the clean-up here in error path.
> 

Best Regards,
Chanwoo Choi





