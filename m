Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbaCSCqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:46:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21072 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbaCSCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:46:07 -0400
X-AuditID: cbfee68f-b7f156d00000276c-a1-532904ecfd59
Message-id: <532904EC.3090101@samsung.com>
Date: Wed, 19 Mar 2014 11:46:04 +0900
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
 <53234132.8080202@samsung.com> <532682A8.2030300@samsung.com>
 <532839A5.8020505@samsung.com>
In-reply-to: <532839A5.8020505@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkRPcNi2awwbkVShYdPb9ZLOYfOcdq
	ce7VSkaLs01v2C0Wti1hsbi8aw6bxefeI4wWM87vY7JYev0ik8XtxhVsFm9+nGWymDB9LYvF
	4xVv2S1eHWxjsVg/4zWLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MqYdPAfW8FxtYqGU+4NjKvluhg5OSQETCTam7axQthiEhfu
	rWfrYuTiEBJYyijx+u8VFpiihStbGSESixgl5v1dwwzhvGKU+LznPFgVr4CWxKFpx5lAbBYB
	VYll8x+D2WxA8f0vbrCB2KICYRIrp1+BqheU+DH5HpgtIqAicfnUdEYQm1ngK5PEzXlgvcIC
	iRLHdk9jgVj2iFGi/cZ9sASngLbE3gXnWSEadCT2t05jg7DlJTaveQt2nYTAVA6J+/tXskNc
	JCDxbfIhoEkcQAlZiU0HmCFek5Q4uOIGywRGsVlIbpqFZOwsJGMXMDKvYhRNLUguKE5KLzLW
	K07MLS7NS9dLzs/dxAiM8tP/nvXvYLx7wPoQYzLQyonMUqLJ+cAkkVcSb2hsZmRhamJqbGRu
	aUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGG2v7xKfLtLMMdX6Ru4CjUnR
	FapsK5Yt2ZTGufbXj/PCijnzBDnkDoS9E/r2fUVTVrJY86KXnO1vs1nMuWWT3in5FmwOOLF/
	d9kNwQtZVuuPbJjw/coPzymnZlmyetb6v+HNXN3lc0DoVKCBg+aJT7Oe/ZX5XFsWpSPA7Vz/
	+3tXvS5rw42ja5RYijMSDbWYi4oTAVdlEAkIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAd03LJrBBo3/xS06en6zWMw/co7V
	4tyrlYwWZ5vesFssbFvCYnF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLN78OMtkMWH6WhaL
	xyveslu8OtjGYrF+xmsWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9LBf2wFx9UqGk65
	NzCuluti5OSQEDCRWLiylRHCFpO4cG89WxcjF4eQwCJGiXl/1zBDOK8YJT7vOc8CUsUroCVx
	aNpxJhCbRUBVYtn8x2A2G1B8/4sbbCC2qECYxMrpV6DqBSV+TL4HZosIqEhcPjUdbBuzwFcm
	iZvzwHqFBRIlju2exgKx7BGjRPuN+2AJTgFtib0LzrNCNOhI7G+dxgZhy0tsXvOWeQKjwCwk
	O2YhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAU8kx6B+OqBotDjAIcjEo8
	vAeiNIKFWBPLiitzDzFKcDArifAK3wUK8aYkVlalFuXHF5XmpBYfYkwGBsFEZinR5Hxgessr
	iTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsatTCGTjbKTgnyn
	X/xuevnrwq6VIt/W6C2rKGrONFN2Cs/NinYMPdHD/rs43v/0ts2sohGhLIr1/0KEHp+Mu5MQ
	+8Y9NLIwSKqTMc8xJzT8g8m/VJXLKk9iFf/dtJ91x2ti7/WHrDl+9zqZ5oTGz3u3tFJSUtzB
	6OTvCt4X5fYBC/aHHly1UImlOCPRUIu5qDgRAG7rOjNlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/18/2014 09:18 PM, Tomasz Figa wrote:
> On 17.03.2014 06:05, Chanwoo Choi wrote:
>> Hi Tomasz,
>>
>> On 03/15/2014 02:49 AM, Tomasz Figa wrote:
>>> Hi Chanwoo,
>>>
>>> On 13.03.2014 09:17, Chanwoo Choi wrote:
>>>> This patch fix bug about resource leak when happening probe fail and code clean
>>>> to add debug message.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> ---
>>>>    drivers/devfreq/exynos/exynos4_bus.c | 32 ++++++++++++++++++++++++++------
>>>>    1 file changed, 26 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>>>> index a2a3a47..152a3e9 100644
>>>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>>>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>>>> @@ -1152,8 +1152,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>>            dev_err(dev, "Cannot determine the device id %d\n", data->type);
>>>>            err = -EINVAL;
>>>>        }
>>>> -    if (err)
>>>> +    if (err) {
>>>> +        dev_err(dev, "Cannot initialize busfreq table %d\n",
>>>> +                 data->type);
>>>>            return err;
>>>> +    }
>>>>
>>>>        rcu_read_lock();
>>>>        opp = dev_pm_opp_find_freq_floor(dev,
>>>> @@ -1176,7 +1179,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>>        if (IS_ERR(data->devfreq)) {
>>>>            dev_err(dev, "Failed to add devfreq device\n");
>>>>            err = PTR_ERR(data->devfreq);
>>>> -        goto err_opp;
>>>> +        goto err_devfreq;
>>>>        }
>>>>
>>>>        /*
>>>> @@ -1185,18 +1188,35 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>>>>         */
>>>>        busfreq_mon_reset(data);
>>>>
>>>> -    devfreq_register_opp_notifier(dev, data->devfreq);
>>>> +    /* Register opp_notifier for Exynos4 busfreq */
>>>> +    err = devfreq_register_opp_notifier(dev, data->devfreq);
>>>> +    if (err < 0) {
>>>> +        dev_err(dev, "Failed to register opp notifier\n");
>>>> +        goto err_notifier_opp;
>>>> +    }
>>>>
>>>> +    /* Register pm_notifier for Exynos4 busfreq */
>>>>        err = register_pm_notifier(&data->pm_notifier);
>>>>        if (err) {
>>>>            dev_err(dev, "Failed to setup pm notifier\n");
>>>> -        devfreq_remove_device(data->devfreq);
>>>> -        return err;
>>>> +        goto err_notifier_pm;
>>>>        }
>>>>
>>>>        return 0;
>>>>
>>>> -err_opp:
>>>> +err_notifier_pm:
>>>> +    devfreq_unregister_opp_notifier(dev, data->devfreq);
>>>> +err_notifier_opp:
>>>> +    /*
>>>> +     * The devfreq_remove_device() would execute finally devfreq->profile
>>>> +     * ->exit(). To avoid duplicate resource free operation, return directly
>>>> +     * before executing resource free below 'err_devfreq' goto statement.
>>>> +     */
>>>
>>> I'm not quite sure about this. I believe that in this case devfreq->profile->exit() would be exynos4_bus_exit() and all it does is devfreq_unregister_opp_notifier(dev, data->devfreq), so all remaining resources (regulators, clocks, etc.) would get leaked.
>>
>> This patch execute following sequence to probe exynos4_busfreq.c:
>>
>> 1. Parse dt node to get resource(regulator/clock/memory address).
>> 2. Enable regulator/clock and map memory.
>> 3. Add devfreq device using devfreq_add_device().
>>     The devfreq_add_device() return devfreq instance(data->devfreq).
>> 4. Register opp_notifier using devfreq instance(data->devfreq) which is created in sequence #3.
>>
>> Case 1,
>> If an error happens in sequence #3 for registering devfreq_add_device(),
>>
>> this case can't execute devfreq->profile->exit() to free resource
>> because this case has failed to register devfreq->profile to devfreq_list.
>>
>> So, must goto 'err_devfreq' statement to free resource(regulator/clock/memory).
>>
>>
>> Case 2,
>> If an error happens in sequence #4 for registering opp_notifier,
>>
>> In contrast
>> this case can execute devfreq->profile->exit() to free resource.
>> But, After executed devfreq->profile->exit(),
>> should not execute 'err_devfreq' statement to free resource.
>> In case, will operate twice of resource.
>>
>> If my explanation is wrong, please reply your comment.
>>
> 
> OK, it will work indeed, however the code is barely readable with this.
> 
> For consistency (and readability), resources acquired in platform driver's .probe() should be freed in .remove() and error path of .probe() should not rely on external code to do the clean-up.
> 
> So, as I proposed in my previous reply:

OK, I'll modify it according to your previous comment.

> 
>>>
>>> I believe the correct thing to do would be to remove the .exit() callback from exynos4_devfreq_profile struct and handle all the clean-up here in error path.
>>>

Best Regards,
Chanwoo Choi
 
