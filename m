Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbaD3Inb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:43:31 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59344 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaD3In1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <5360B538.3020104@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
	<1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
	<534506B1.4040908@samsung.com>
	<5345333D.4080505@saftware.de>
	<CAPdUM4OOaaP2byJa+MgksAaDtsffwqTYT-obfVEBsRxjy_vKrg@mail.gmail.com>
	<5360B538.3020104@samsung.com>
Date: Wed, 30 Apr 2014 14:13:25 +0530
Message-ID: <CAPdUM4PU54u3x+VEC4dRbJ-HL73ruG+WJUZF9KTS6GcB0Sb8HA@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <r.sh.open@gmail.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Andreas Oberritter <obi@saftware.de>, Andrzej Hajda <a.hajda@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure (5250, 5420). I will wait for the same to update DT patches, if any.

Regards,
Rahul Sharma.

On 30 April 2014 14:02, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
> Hi Rahul,
> I will prepare we v3 version.
> Do you want me to add your patches for exynos5?50 to the patchset?
> Regards,
> Tomasz Stanislawski
>
> On 04/30/2014 08:37 AM, Rahul Sharma wrote:
>> Hi Tomasz,
>>
>> I have tested your patches for exynos5250 and 5420. Works fine. Are
>> you planning to post v3? If you want I can share hand with you for v3.
>>
>> Regards,
>> Rahul Sharma
>>
>> On 9 April 2014 17:17, Andreas Oberritter <obi@saftware.de> wrote:
>>> Hello Andrzej,
>>>
>>> On 09.04.2014 10:37, Andrzej Hajda wrote:
>>>>> +static int exynos_phy_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +    const struct of_device_id *of_id = of_match_device(
>>>>> +            of_match_ptr(exynos_phy_of_match), &pdev->dev);
>>>>> +    const u32 *offsets = of_id->data;
>>>>> +    int count;
>>>>> +    struct device *dev = &pdev->dev;
>>>>> +    struct phy **phys;
>>>>> +    struct resource *res;
>>>>> +    void __iomem *regs;
>>>>> +    int i;
>>>>> +    struct phy_provider *phy_provider;
>>>>> +
>>>>> +    /* count number of phys to create */
>>>>> +    for (count = 0; offsets[count] != ~0; ++count)
>>>>> +            ;
>>>>
>>>> count = ARRAY_SIZE(offsets) - 1;
>>>
>>> u32 *offsets is not an array.
>>>
>>> Regards,
>>> Andreas
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
