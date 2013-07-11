Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab3GKEao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:30:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41733 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3GKEam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:30:42 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-85-51de34f0510b
Message-id: <51DE34F1.4010001@samsung.com>
Date: Thu, 11 Jul 2013 13:30:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH V3] extcon: palmas: Option to disable ID/VBUS detection
 based on platform
References: <1373448546-7531-1-git-send-email-ldewangan@nvidia.com>
 <51DE1B99.6090403@samsung.com> <51DE219B.7000109@nvidia.com>
In-reply-to: <51DE219B.7000109@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkQPeDyb1Ag09H9C0OzH7IatG/xcXi
	wtMeNoul+1azWCxsW8JicXnXHDaL240r2CzWvZzO4sDh8Wr1TFaP8zMWMnr0Nr9j8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2KyyYlNSezLLVI3y6BK2PPk3tMBYf5K/rWfGJtYDzP3cXIySEh
	YCLx88c8ZghbTOLCvfVsXYxcHEICSxkldm96zwhTdO94LxNEYjqjxP/LvSwQzitGibs71jGB
	VPEKaEm0flgENIqDg0VAVWLVHB+QMBtQeP+LG2wgtqhAmMTK6VdYIMoFJX5MvgdmiwDVfDvw
	jxlkJrPATyaJbVMvsIMkhAXiJf4++skKYgsJNDFK9G8QBbE5gRrutswFu45ZQEdif+s0Nghb
	XmLzmrdggyQEHrFLXJv7FqyIRUBA4tvkQywgx0kIyEpsOgD1sqTEwRU3WCYwis1CctMsJGNn
	IRm7gJF5FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgVJ7+92zCDsZ7B6wPMSYDrZzILCWa
	nA+M6rySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MHr8SXoqqxE1wVL1MuuUDf8OLLQ/3m382z1sjYrFsZtdJTHieyuZpE75vZJcFvk3Qzq55yHr
	ifuFbc84ZN6L++tn6hb9ZrNTNZnN8OV+ifxMsZa6F1duP3Z4vP7+jqWv4l3FRLznKDokPF2U
	d+eAw4apgq5v2JNPH31oIRl6e7p8Yr7nh+8N7UosxRmJhlrMRcWJAKNyMEPgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd0PJvcCDX7eV7c4MPshq0X/FheL
	C0972CyW7lvNYrGwbQmLxeVdc9gsbjeuYLNY93I6iwOHx6vVM1k9zs9YyOjR2/yOzaNvyypG
	j6lT/jJ6HL+xncnj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	e57cYyo4zF/Rt+YTawPjee4uRk4OCQETiXvHe5kgbDGJC/fWs3UxcnEICUxnlPh/uZcFwnnF
	KHF3xzqwKl4BLYnWD4uYuxg5OFgEVCVWzfEBCbMBhfe/uMEGYosKhEmsnH6FBaJcUOLH5Htg
	tghQzbcD/5hBZjIL/GSS2Db1AjtIQlggXuLvo5+sILaQQBOjRP8GURCbE6jhbstcRhCbWUBH
	Yn/rNDYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+du
	YgTH/DPpHYyrGiwOMQpwMCrx8DbE3w0UYk0sK67MPcQowcGsJMJ7cgpQiDclsbIqtSg/vqg0
	J7X4EGMyMAQmMkuJJucD01FeSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KL
	YLYwcXBKNTC2FRtZraubdnl74vyyuFM+8d1pU5LX8ju5P7q+/RP3PyHF2KJ7iYzOnltVOI17
	14cqrnsxN9ikmi/rilvyz/Pvc5Yu5qwo/SEQaDKvkcFsF6u5u/RuG5YVa3mOc6YZh77o5l5o
	dsbv3xSej16BZgfqQ6V07FcHcW1bsJT1URafcM1jrlqDY0osxRmJhlrMRcWJALPNjeM9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 12:08 PM, Laxman Dewangan wrote:
> On Thursday 11 July 2013 08:12 AM, Chanwoo Choi wrote:
>> Hi Laxman,
>>
>>>   static int palmas_usb_probe(struct platform_device *pdev)
>>> @@ -137,20 +140,26 @@ static int palmas_usb_probe(struct platform_device *pdev)
>>>       struct palmas_usb *palmas_usb;
>>>       int status;
>>>   -    if (node && !pdata) {
>>> -        pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>>> -
>>> -        if (!pdata)
>>> -            return -ENOMEM;
>>> +    palmas_usb = devm_kzalloc(&pdev->dev, sizeof(*palmas_usb), GFP_KERNEL);
>>> +    if (!palmas_usb)
>>> +        return -ENOMEM;
>>>   -        pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
>>> +    if (node && !pdata) {
>>> +        palmas_usb->wakeup = of_property_read_bool(node, "ti,wakeup");
>>> +        palmas_usb->enable_id_detection = of_property_read_bool(node,
>>> +                        "ti,enable-id-detection");
>>> +        palmas_usb->enable_vbus_detection = of_property_read_bool(node,
>>> +                        "ti,enable-vbus-detection");
>>> +    } else if (pdata) {
>>> +        palmas_usb->wakeup = pdata->wakeup;
>>> +        palmas_usb->enable_id_detection = true;
>>> +        palmas_usb->enable_vbus_detection = true;
>>>       } else if (!pdata) {
>>> -        return -EINVAL;
>>> +        palmas_usb->wakeup = true;
>>> +        palmas_usb->enable_id_detection = true;
>>> +        palmas_usb->enable_vbus_detection = true;
>>>       }
>> I think we could modify it as following patch to remove duplicate line.
>> If you agree about below modification, I will apply your patch with following patch.
>>
> I am fine with this and this looks simple and straight.
> 
> I have seen some patches/discussion from TI to remove the platform data support at all and hence removing from here in future will be very simple.
> 

This patch is applied on extcon-linus branch.

Thanks,
Chanwoo Choi

