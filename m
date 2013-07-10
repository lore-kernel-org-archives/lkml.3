Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3GJHe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:34:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42935 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3GJHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:34:57 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-35-51dd0e9ff0a4
Message-id: <51DD0E9F.1030305@samsung.com>
Date: Wed, 10 Jul 2013 16:34:55 +0900
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
Subject: Re: [PATCH V2 4/4] extcon: palmas: Option to disable ID/VBUS detection
 based on platform
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
 <1373436959-32444-5-git-send-email-ldewangan@nvidia.com>
 <51DD0578.6090804@samsung.com> <51DD09B7.50604@nvidia.com>
In-reply-to: <51DD09B7.50604@nvidia.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkRHc+391Ag8db+S0OzH7IatG/xcXi
	wtMeNoul+1azWCxsW8JicXnXHDaL240r2CzWvZzO4sDh8Wr1TFaP8zMWMnr0Nr9j8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2KyyYlNSezLLVI3y6BK6N78xXWgp0iFYceHGJtYDwt0MXIySEh
	YCIxc/cjVghbTOLCvfVsXYxcHEICSxklTi77D5TgACuacVAEIr6IUWLZzy+sEM4rRonbDZfY
	Qbp5BbQkfrycwwxiswioSrTcm8wGYrMBxfe/uAFmiwqESaycfoUFol5Q4sfke2C2CFDNtwP/
	mEGGMgv8ZJLYNvUC2FBhgWSJm51fmSG27WGUeHjmOjPISZwCGhKH32aA1DALqEtMmreIGcKW
	l9i85i1YvYTAS3aJvmdX2SAuEpD4NvkQC8Q7shKbDjBDvCwpcXDFDZYJjGKzkNw0C8nYWUjG
	LmBkXsUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGJWn/z2bsIPx3gHrQ4zJQCsnMkuJJucD
	ozqvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzt
	5m5zlBsilIvm3q/ifKC6efs+Ps8whfszZ7G8nH3o4gG9DaKv75xSDGM4wvygdBPHNMYk1Q95
	zmteTvxx9exynoj78z309vPVtE14mXPG3ddh13P+SZZeWb90/9wPvsGi98dWoKXq/4NjC9z+
	S2/tNZy17ExIT3CZq6b/ktYzUvcvFqnoZB9QYinOSDTUYi4qTgQADE0Z8uACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd35fHcDDebvZ7c4MPshq0X/FheL
	C0972CyW7lvNYrGwbQmLxeVdc9gsbjeuYLNY93I6iwOHx6vVM1k9zs9YyOjR2/yOzaNvyypG
	j6lT/jJ6HL+xncnj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	3ZuvsBbsFKk49OAQawPjaYEuRg4OCQETiRkHRboYOYFMMYkL99azdTFycQgJLGKUWPbzCyuE
	84pR4nbDJXaQKl4BLYkfL+cwg9gsAqoSLfcms4HYbEDx/S9ugNmiAmESK6dfYYGoF5T4Mfke
	mC0CVPPtwD9mkKHMAj+ZJLZNvQA2VFggWeJm51dmiG17GCUenrnODHIep4CGxOG3GSA1zALq
	EpPmLWKGsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwzD+T2sG4ssHiEKMAB6MSD+8BhTuBQqyJZcWVuYcYJTiYlUR4/10CCvGmJFZWpRblxxeV
	5qQWH2JMBgbBRGYp0eR8YDrKK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGRZ9t7s9u33Pi9j2pvOzw6OsxkfW3riktaZnNt6b7aQHjzBun70TtDhBe8fiU
	tM5X/r7i22oTJr99djDV97vkhQ9KiRcTD68+tcFqwuvfscdkChOOijRdLFILOc58d9Ls0M1t
	aw/Xn97cem/ilfUTuwsz/ho6T/VU0FlxZK2G/OTn3Vx684ycJJVYijMSDbWYi4oTAZSPXKc9	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:13 PM, Laxman Dewangan wrote:
> On Wednesday 10 July 2013 12:25 PM, Chanwoo Choi wrote:
>> Hi Laxman,
>>
>> On 07/10/2013 03:15 PM, Laxman Dewangan wrote:
>>> Should you define duplicate meaning variables in each other structure?
>>> - disable_vbus_detection - enable_vbus_detection
>>> - disable_id_detection - enable_id_detection
>>>
>>> I think that it isn' efficient code. I'd like you to simplify this patch
>>> by using only one variable instead of duplicate meaning variables.
> 
> Originally this patch came form TI and not sure that they are using the both cable detection or only single type.
> For Nvidia Tegra platform, on some design, we are using only ID detection and hence this option get added.
> 

I agree that user can determine whether specific irq is used or not according to dt data.


> I did not like to break the TI design/code and hence added the option such that if there is no initialisation of this member or dts entry then assume it as the cable detection is enabled. Hence it need explicitly entry for disable the cable type detction. This is what for platform data structure.
> 
> On other structure, I use as other way to use in rest of code to make logic as
> 
> if (palmas_usb->enable_id_detction)
>    xxx.
> 
> rathar than
> 
> if (!palmas_usb->disable_id_detction)
>    xxx.
> 
> 
> On rest of code, do now wan to use the pdata.

This patch store same meaning to two different variables which are included in different structure.
If we try to change the state of vbus/id detection on runtime, we have to modify two variables.
I think it isn't right.

struct palmas_platform_data {
	....
	bool disable_vbus_detection;
	bool disable_id_detection;
};

struct palmas_usb {
	...
	bool enable_vbus_detection;
	bool enable_id_detection;
};

You could only use the variables in struct palmas_usb without variables in struct palmas_platform_data
because extcon-palmas driver store only the pointer of 'struct palmas_usb' to dev->p->driver_data
by using platform_set_drvdata().

It is meaning to use 'struct palmas_usb' on other function except for palmas_usb_probe() in extcon-palmas.c.


if (node && !pdata) {
	...
	palmas_usb->wakeup = of_property_red_bool(node, "ti,wakeup);
	palmas_usb->enable_vbus_detection = of_property_red_bool(node, "ti,enable_vbus_detection);
	palmas_usb->enable_id_detection = of_property_red_bool(node, "ti,enable_id_detection);
} else (!pdata) {
	palmas_usb->wakeup = true;
	palmas_usb->enable_vbus_detection = true;
	palmas_usb->enable_id_detection = true;
}







