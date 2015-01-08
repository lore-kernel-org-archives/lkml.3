Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbbAHLHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:07:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41962 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbbAHLHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:07:34 -0500
X-AuditID: cbfee68d-f79296d000004278-72-54ae64f3be4c
Message-id: <54AE6501.8020905@samsung.com>
Date: Thu, 08 Jan 2015 16:37:45 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, kernel@pengutronix.de,
        Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
 <35536202.10QfWIDQqq@wuerfel> <1420628264.3191.27.camel@pengutronix.de>
 <54AD15E5.5070803@samsung.com> <1420631728.3191.52.camel@pengutronix.de>
In-reply-to: <1420631728.3191.52.camel@pengutronix.de>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkVvdzyroQg7YP0hZ/Jx1jt2i7cpDd
	4v+j16wWR38XWKyaupPF4v7Xo4wWl3fNYbO4e+8Ei8XpblaLVbv+MDpwefz+NYnR4+/z6ywe
	O2fdZfe4c20Pm8e8k4Ee/X8NPPq2rGL02H5tHrPH501yAZxRXDYpqTmZZalF+nYJXBl3prxm
	LZhlXrHr8EuWBsZ72l2MnBwSAiYS/1e0skLYYhIX7q1n62Lk4hASWMoosWbVUlaYor6Zf5kg
	EosYJZ5e+QlV1cokcfL/azaQKl4BLYlj7VsZQWwWAVWJ9rMbmEFsNgFdiSfv54LZogIREh9W
	fYWqF5T4MfkeC4gtAtT79Mo9sDizwBUmif3bM0FsYQEbiT1nr4LNFBK4zShx/3w2iM0pYCbx
	ZnkjO0S9mcSXl4dZIWx5ic1r3jKDHCch8JNdor1xITPEQQIS3yYfAlrGAZSQldh0gBniM0mJ
	gytusExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAuD3971nv
	DsbbB6wPMQpwMCrx8H64vzZEiDWxrLgy9xCjKdAVE5mlRJPzgckhryTe0NjMyMLUxNTYyNzS
	TEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjPNy9HvP77aEP2bobzgV1O+03HG
	mdMb9LKnfH4zJbv3REqu4HlnIabfgZbVm10/ivj+/PNgyWPRqV+V6g8f5GWxK+hwTIs59G7G
	S6HsAuGKqlVej2fcynq4gvWWIefp39KmM2+8CL+j4XAutTYgJd3stPLn2rfuO5/wKOu1/j1/
	6L6bUs5TZSWW4oxEQy3mouJEAMZuo7fWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7nlHUhBvsnC1v8nXSM3aLtykF2
	i/+PXrNaHP1dYLFq6k4Wi/tfjzJaXN41h83i7r0TLBanu1ktVu36w+jA5fH71yRGj7/Pr7N4
	7Jx1l93jzrU9bB7zTgZ69P818OjbsorRY/u1ecwenzfJBXBGNTDaZKQmpqQWKaTmJeenZOal
	2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCdqaRQlphTChQKSCwuVtK3wzQhNMRN
	1wKmMULXNyQIrsfIAA0krGHMuDPlNWvBLPOKXYdfsjQw3tPuYuTkkBAwkeib+ZcJwhaTuHBv
	PVsXIxeHkMAiRomnV35COa1MEif/v2YDqeIV0JI41r6VEcRmEVCVaD+7gRnEZhPQlXjyfi6Y
	LSoQIfFh1VeoekGJH5PvsYDYIkC9T6/cA4szC1xhkti/PRPEFhawkdhz9irYTCGB24wS989n
	g9icAmYSb5Y3skPUm0l8eXmYFcKWl9i85i3zBEaBWUhWzEJSNgtJ2QJG5lWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwUnhmdQOxpUNFocYBTgYlXh4P9xfGyLEmlhWXJl7iFGCg1lJhFfH
	c12IEG9KYmVValF+fFFpTmrxIUZTYAhMZJYSTc4HJqy8knhDYxNzU2NTSxMLEzNLJXFeJfu2
	ECGB9MSS1OzU1ILUIpg+Jg5OqQZG97n1KWc9Du/89vvZ5knHWk6p5BS5Hea+KnY2rL7h6yZr
	Y+eXfp/djxse05wRFsib0OVwfo9ozC0Du43zjm/bYP6uITvl5JaixY22e7dwHI/p4AlsntPZ
	5rOGa1nqvkklFy2vrzx5eFbits5zDCLuna+PLP67QC5Oa8mOz0euKRVvmLRLl8f/nxJLcUai
	oRZzUXEiAMi/b94gAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wednesday 07 January 2015 05:25 PM, Philipp Zabel wrote:
> Hi Pankaj,
>
> Am Mittwoch, den 07.01.2015, 16:47 +0530 schrieb Pankaj Dubey:
>> Hi Philipp,
>>
>> On Wednesday 07 January 2015 04:27 PM, Philipp Zabel wrote:
>>> Am Dienstag, den 06.01.2015, 20:36 +0100 schrieb Arnd Bergmann:
>>>> On Tuesday 06 January 2015 16:30:36 Philipp Zabel wrote:
>>>>> Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
>>>>> breaks probing pure syscon devices from device tree, such as anatop and
>>>>> iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
>>>>> "syscon" compatible device tree nodes.
>>>>>
>>>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>>>
>>>>
>>>> I don't understand it. Why is this required?
>>>
>>> The debugfs entries vanished and I'd like to have a device to register
>>> platform device children to.
>>
>> Yes debugfs entries will not be present for syscon, this is as per
>> discussion happened here [1]. At that time one suggestion came from Arnd
>> that we can have a different representation for syscon regmaps, instead
>> of based on devices just based on of_node pointer.
>>
>> 1: https://lkml.org/lkml/2014/9/26/73
>
> Thank you for the pointer. That would work for me just as well.
>

Well, But so far I do not see any attempt has been done for making this 
kind of debugfs entry using of_node pointer.

>> I was just thinking, missing debugfs entry is your concern, or you want
>> to make child devices of syscon devices? Basically I am still trying to
>> understand your requirement.
>
> Both. I'd like to somehow get the debug entry back, whether by
> optionally associating syscon with a device or by adding special syscon
> support to regmap.
> And I'd like to eventually register platform devices under the syscon
> node in the device tree. Currently in the i.MX device tree we have three
> overlapping nodes next to each other:
>
> 	gpr: iomuxc-gpr@20e00000 {
> 		compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> 		reg = <0x020e0000 0x38>;
> 	};
>
> 	iomuxc: iomuxc@020e0000 {
> 		compatible = "fsl,imx6q-iomuxc";
> 		reg = <0x020e0000 0x4000>;
> 	};
>
> 	ldb: ldb@020e0008 {
> 		compatible = "fsl,imx6q-ldb";
> 		gpr = <&gpr>;
> 	};
>
> The ldb device is controlled purely through the gpr regmap, so in my
> opinion it should be a child to the iomuxc-gpr node:
>
> 	gpr: iomuxc-gpr@20e00000 {
> 		compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> 		reg = <0x020e0000 0x38>;
>
> 		ldb: ldb@020e0008 {
> 			compatible = "fsl,imx6q-ldb";
> 			gpr = <&gpr>;
> 		};
> 	};
>
> 	iomuxc: iomuxc@020e0000 {
> 		compatible = "fsl,imx6q-iomuxc";
> 		reg = <0x020e0000 0x4000>;
> 	};
>
> In that case, if there is no device associated with iomuxc-gpr, which
> device should be the parent to ldb?If the syscon is created from the
> iomuxc device, the ldb device could be made a child to iomuxc.

If you need ldb as child device of gpr, then there is no need of syscon 
or SYSCON APIs here in ldb. In my opinion this is an extra feature which 
are trying to feed into syscon. As in case of sibling devices it makes 
sense to access registers across them using syscon APIs, but in case of 
parent-child devices we already have MFD drivers, and MFD client devices 
which can serve this purpose.

> In fact, since the gpr registers are part of the iomuxc register space,
> one could even think about merging the iomuxg-gpr syscon into the iomuxc
> node:
>
> 	gpr: iomuxc: iomuxc@020e0000 {
> 		compatible = "fsl,imx6q-iomuxc", "fsl,imx6q-iomuxc-gpr";
> 		reg = <0x020e0000 0x4000>;
>
> 		ldb: ldb@020e0008 {
> 			compatible = "fsl,imx6q-ldb";
> 		};
> 	};
>
>> I guess for i.MX iomuxc it could be argued
>>> that the iomuxc-gpr syscon should be merged into the iomuxc pinctrl
>>> device instead of probing iomuxc-gpr as a platform device by itself.

Yes, also in the probe of this driver you can register itself as MFD 
driver and all the child devices and MFD client devices so that child 
devices can be probed. For example a similar approach has been attempted 
for exynos-pmu here [1].

1: http://www.spinics.net/lists/linux-samsung-soc/msg38446.html

While doing this you can still keep "syscon" compatible to the gpr node 
if it's some of it's register will be accessed from some other devices.
But definitely ldb does not need to have a phandle to this syscon 
device, as after being a MFD client device it can access MFD parent 
device address space.

>>> How about allowing to register a syscon for a given device:
>>>
>>> ----8<----
>>> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>>> index d2280d6..2633b27 100644
>>> --- a/drivers/mfd/syscon.c
>>> +++ b/drivers/mfd/syscon.c
>>> @@ -42,13 +42,14 @@ static struct regmap_config syscon_regmap_config = {
>>>    	.reg_stride = 4,
>>>    };
>>>
>>> -static struct syscon *of_syscon_register(struct device_node *np)
>>> +struct syscon *syscon_register(struct device *dev, struct device_node *np)
>>>    {
>>>    	struct syscon *syscon;
>>>    	struct regmap *regmap;
>>>    	void __iomem *base;
>>>    	int ret;
>>>    	struct regmap_config syscon_config = syscon_regmap_config;
>>> +	struct resource res;
>>>
>>>    	if (!of_device_is_compatible(np, "syscon"))
>>>    		return ERR_PTR(-EINVAL);
>>> @@ -57,7 +58,12 @@ static struct syscon *of_syscon_register(struct device_node *np)
>>>    	if (!syscon)
>>>    		return ERR_PTR(-ENOMEM);
>>>
>>> -	base = of_iomap(np, 0);
>>> +	if (of_address_to_resource(np, 0, &res)) {
>>> +		ret = -ENOMEM;
>>> +		goto err_map;
>>> +	}
>>> +
>>> +	base = ioremap(res.start, resource_size(&res));
>>>    	if (!base) {
>>>    		ret = -ENOMEM;
>>>    		goto err_map;
>>> @@ -69,7 +75,8 @@ static struct syscon *of_syscon_register(struct device_node *np)
>>>    	 else if (of_property_read_bool(np, "little-endian"))
>>>    		syscon_config.val_format_endian = REGMAP_ENDIAN_LITTLE;
>>>
>>> -	regmap = regmap_init_mmio(NULL, base, &syscon_config);
>>> +	syscon_regmap_config.max_register = res.end - res.start - 3;
>>> +	regmap = regmap_init_mmio(dev, base, &syscon_config);
>>>    	if (IS_ERR(regmap)) {
>>>    		pr_err("regmap init failed\n");
>>>    		ret = PTR_ERR(regmap);
>>> @@ -91,6 +98,12 @@ err_map:
>>>    	kfree(syscon);
>>>    	return ERR_PTR(ret);
>>>    }
>>> +EXPORT_SYMBOL_GPL(syscon_register);
>>> +
>>
>> In past a similar approach [2] for letting device driver to register
>> themselves as syscon provided, has been rejected giving reason that
>> syscon should not need it's own platform device.
>
> In that mail Arnd mentions registering a syscon with both an optional
> device and an explicit device_node pointer, which is what this patch
> would do. There is no need for a platform device.
>

I don't think so, as per I recall he was against of any such extra API 
to register syscon [2].

2: https://lkml.org/lkml/2014/9/1/227

> regards
> Philipp
>
>
