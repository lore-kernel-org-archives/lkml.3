Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaDRAJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:09:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39293 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDRAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:09:48 -0400
X-AuditID: cbfee690-b7f266d00000287c-6a-53506d4bb016
Message-id: <53506D51.2070808@samsung.com>
Date: Fri, 18 Apr 2014 09:09:53 +0900
From: Sangjung <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cwchoi00@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCHv2 8/8] extcon: arizona: Use devm_extcon_dev_register()
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
 <1397729403-32045-9-git-send-email-sangjung.woo@samsung.com>
 <CAGTfZH0m0YT0Dj7ZavrFrTe-h5J49DausNWnEtcRxxEmqtr3KQ@mail.gmail.com>
In-reply-to: <CAGTfZH0m0YT0Dj7ZavrFrTe-h5J49DausNWnEtcRxxEmqtr3KQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkQNc7NyDYYPUOYYvrX56zWjw7qm3x
	+oWhxeVdc9gsbjeuYLOYMfklmwObx85Zd9k9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Pf
	35+sBe+lKz7NqmlgvC/SxcjJISFgItG8eRMjhC0mceHeerYuRi4OIYGljBIXN99ghSlasWIe
	C0RiEaPEr1ctbCAJIYHXjBKzzomC2LwCWhJLJv0GauDgYBFQlXj4Mg0kzCagKfH5+EGwclGB
	CIm5EzezQZQLSvyYfI8FxBYBKp9yr5MdZD6zwF1GiSVPXoNdJCzgJbGw/xAjxOJzjBIn9jaC
	JTgFgiW6H14Hs5kFzCQetaxjhrDlJTavecsMcfUudomDrekgNouAgMS3yYdYQI6TEJCV2HQA
	qkRS4uCKGywTGMVmIblpFpKps5BMXcDIvIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMKZO
	/3s2YQfjvQPWhxiTgVZOZJYSTc4HxmReSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTA2vTk3meWw/proqWWptSs/KO5e/u6xzMp5MZPX5u5tvvSR
	bZLw1tRFm0yLj9XN8p4RFdTjwLT4e3Fnk3R/Wcq+2d2Pjpj4TH2UyPyF2WnNY7Fv2m4eBXKz
	rI5InGT/NP2tBu9O1aCHrKUC5tNb4pkLZzGGr3G9eHF9rGWlx1+GMp+k2QdKjbYqsRRnJBpq
	MRcVJwIAsdE3QL8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK53bkCwwbwebovrX56zWjw7qm3x
	+oWhxeVdc9gsbjeuYLOYMfklmwObx85Zd9k9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8l
	My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjFj39+frAXvpSs+zappYLwv0sXIySEhYCKxYsU8FghbTOLC
	vfVsXYxcHEICixglfr1qYQNJCAm8ZpSYdU4UxOYV0JJYMuk3axcjBweLgKrEw5dpIGE2AU2J
	z8cPgpWLCkRIzJ24mQ2iXFDix+R7YPNFgMqn3OtkB5nPLHCXUWLJk9eMIAlhAS+Jhf2HGCEW
	n2OUOLG3ESzBKRAs0f3wOpjNLGAm8ahlHTOELS+xec1b5gmMArOQLJmFpGwWkrIFjMyrGEVT
	C5ILipPSc430ihNzi0vz0vWS83M3MYJj9pn0DsZVDRaHGAU4GJV4eC989Q8WYk0sK67MPcQo
	wcGsJMJ7Pi0gWIg3JbGyKrUoP76oNCe1+BBjMjAIJjJLiSbnA9NJXkm8obGJmZGlkbmhhZGx
	OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwSvo+WJ+yktllwrmLVgEzlDftuRCzKehk
	btf0jqMd249tS80Inm6//Idu8NuZUu6qnRviLiYlqVlt/BbcdS9yx4uTva7lAvFc4le3W/g6
	3tq1Z6ewV1HpFA5Dv7Ul3pIpSQyzD2eanL3xk/XMsQ8NukeFT0juFn1hU9eodv/RTqftHauT
	lgfcVWIpzkg01GIuKk4EAAn5BeYdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo.

On 04/18/2014 12:29 AM, Chanwoo Choi wrote:
> Hi Sangjung,
>
> Seung-Woo reviewed this patch previously but, He didn't send
> reviewed-by message as reply.
> After received reviewed-by message, I think that we should add it on
> patch description.

Frankly speaking, I didn't know the basic acknowledge procedure of Linux 
Kernel development.
Thank you for your advice.

I will add the _reviewed-by_ message after I get it from Seung-woo.

BRs,
Sangjung

> Thanks,
> Chanwoo Choi
>
> On Thu, Apr 17, 2014 at 7:10 PM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
>> Use the resource-managed extcon device register function (i.e.
>> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
>> is attached with this function, that extcon device is automatically unregistered
>> on driver detach. That reduces tiresome managing code.
>>
>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>> Reviewed-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> ---
>>   drivers/extcon/extcon-arizona.c |   13 ++++---------
>>   1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>> index 98a14f6..40e6c0b 100644
>> --- a/drivers/extcon/extcon-arizona.c
>> +++ b/drivers/extcon/extcon-arizona.c
>> @@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>>          info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>>          if (!info) {
>>                  dev_err(&pdev->dev, "Failed to allocate memory\n");
>> -               ret = -ENOMEM;
>> -               goto err;
>> +               return -ENOMEM;
>>          }
>>
>>          info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
>>          if (IS_ERR(info->micvdd)) {
>> -               ret = PTR_ERR(info->micvdd);
>>                  dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
>> -               goto err;
>> +               return PTR_ERR(info->micvdd);
>>          }
>>
>>          mutex_init(&info->lock);
>> @@ -1155,11 +1153,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>>          info->edev.dev.parent = arizona->dev;
>>          info->edev.supported_cable = arizona_cable;
>>
>> -       ret = extcon_dev_register(&info->edev);
>> +       ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
>>          if (ret < 0) {
>>                  dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
>>                          ret);
>> -               goto err;
>> +               return ret;
>>          }
>>
>>          info->input = devm_input_allocate_device(&pdev->dev);
>> @@ -1410,8 +1408,6 @@ err_rise:
>>   err_input:
>>   err_register:
>>          pm_runtime_disable(&pdev->dev);
>> -       extcon_dev_unregister(&info->edev);
>> -err:
>>          return ret;
>>   }
>>
>> @@ -1445,7 +1441,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
>>          regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
>>                             ARIZONA_JD1_ENA, 0);
>>          arizona_clk32k_disable(arizona);
>> -       extcon_dev_unregister(&info->edev);
>>
>>          return 0;
>>   }
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

