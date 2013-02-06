Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3BFBsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:48:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24453 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BFBsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:48:21 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-a9-5111b66359de
Message-id: <5111B665.7000006@samsung.com>
Date: Wed, 06 Feb 2013 10:48:21 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sean Paul <seanpaul@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "kgene.kim" <kgene.kim@samsung.com>,
        devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        RAHUL SHARMA <rahul.sharma@samsung.com>
Subject: Re: [PATCH v3 1/3] drm/exynos: Get HDMI version from device tree
References: <1360107777-17490-1-git-send-email-seanpaul@chromium.org>
 <1360107777-17490-2-git-send-email-seanpaul@chromium.org>
 <5111A23F.50300@wwwdotorg.org>
 <CAOw6vb+W3phFDJXp3gCx7y0N7mF4o2DpEfTGuNT1pGdKqiCGTg@mail.gmail.com>
 <5111A6D9.7090700@wwwdotorg.org>
 <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
In-reply-to: <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zLd3kbYKBBrd/aFpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUsObuBteCDWsWbjn6mBsZFcl2MnBwSAiYS3z5tZIew
	xSQu3FvP1sXIxSEksIxR4ubEv6wwRY/XNrNCJKYzStxb8h3Kecko8e7yT0aQKl4BLYmFL66C
	jWIRUJX4tOsXWJxNQE/izrbjTCC2qECYxMrpV1gg6gUlfky+B2RzcIgA1c+7kg8yk1ngH7PE
	jNuHwTYLC3hK7Np1kxli2WUmiQf7/7CBJDgFgiV2ndoCZjMLWEusnLSNEcKWl9i85i1Yg4RA
	P7vEjQtrmCEuEpD4NvkQ2DYJAVmJTQeYIV6TlDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECIkQqR2MKxssDjEKcDAq8fDe0BMMFGJNLCuuzD3EKMHB
	rCTCy7EaKMSbklhZlVqUH19UmpNafIgxGejAicxSosn5wOjNK4k3NDYwNjS0NDQztTQ1IE1Y
	SZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MNWUcHjyz7f0vPFB4rWI0V1zHfZH8hq8frGuj
	L0w+sX77X2O/XwGi+UkCs/ofdzWu/Gl9bG3P3ZufHx+0L/u0Ukr4RZ2ig/P6fT8eGRzpLhF6
	wXpo4gx1xpK9XaV5llVTtcV8r8hy72cO+icmoLJ7O0tYycGw1XF5W9zjfi64O29+9MGQnt8P
	lViKMxINtZiLihMBqBXs19QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd3kbYKBBpPvylhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmLDm7gbXgg1rF
	m45+pgbGRXJdjJwcEgImEo/XNrNC2GISF+6tZ+ti5OIQEpjOKHFvyXdWCOclo8S7yz8ZQap4
	BbQkFr64yg5iswioSnza9QssziagJ3Fn23EmEFtUIExi5fQrLBD1ghI/Jt8Dsjk4RIDq513J
	B5nJLPCPWWLG7cNgm4UFPCV27brJDLHsMpPEg/1/2EASnALBErtObQGzmQWsJVZO2sYIYctL
	bF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg+HsmtYNx
	ZYPFIUYBDkYlHt4beoKBQqyJZcWVuYcYJTiYlUR4OVYDhXhTEiurUovy44tKc1KLDzEmA4Ng
	IrOUaHI+MDXklcQbGpuYGVkamRmbmBsbkyasJM7LeOpJgJBAemJJanZqakFqEcwWJg5OqQbG
	CXeXXZ+3KCYz3k2bV53jl75sfHDnFaUE+Sv54vFcsl+tpl7fIKf1/7KiRtm8mZsN/977+apg
	6+47+1srtGeFNF4WCmqxOCVjLN1Vu0tpqZpOqolZzLfn+/JNTe9bFS/hnbWfyXZWawCTQaV9
	euS3RXtlfFdafohv1n1hVuTxtmWvgf1Vz0wlluKMREMt5qLiRAAXnWn8AwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 09:56 AM, Sean Paul wrote:
> On Tue, Feb 5, 2013 at 4:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/05/2013 05:37 PM, Sean Paul wrote:
>>> On Tue, Feb 5, 2013 at 4:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> n 02/05/2013 04:42 PM, Sean Paul wrote:
>>>>> Use the compatible string in the device tree to determine which
>>>>> registers/functions to use in the HDMI driver. Also changes the
>>>>> references from v13 to 4210 and v14 to 4212 to reflect the IP
>>>>> block version instead of the HDMI version.
>>>>> diff --git a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
>>>> Binding looks sane to me.
>>>>
>>>>> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
>>>>>   #ifdef CONFIG_OF
>>>>>   static struct of_device_id hdmi_match_types[] = {
>>>>>        {
>>>>> -             .compatible = "samsung,exynos5-hdmi",
>>>>> -             .data   = (void *)HDMI_TYPE14,
>>>>> +             .compatible = "samsung,exynos4-hdmi",
>>>>>        }, {
>>>>>                /* end node */
>>>>>        }
>>>> Why not fill in all the "base" compatible values there (I think you need
>>>> this anyway so that DTs don't all have to be compatible with
>>>> samsung,exynos4-hdmi), with .data containing the HDMI_VER_EXYNOS*
>>>> values, then ...
>>>>
>>> At the moment, all DTs have to be compatible with exynos4-hdmi since
>>> it provides the base for the current driver. The driver uses 4210 and
>>> 4212 to differentiate between different register addresses and
>>> features, but most things are just exynos4-hdmi compatible.
>> The DT nodes should include only the compatible values that the HW is
>> actually compatible with. If the HW isn't compatible with exynos4-hdmi,
>> that value shouldn't be in the compatible property, but instead whatever
>> the "base" value that the HW really is compatible with. The driver can
>> support multiple "base" compatible values from this table.
>>
> All devices that use this driver are compatible, at some level, with
> exynos4-hdmi, so I think its usage is correct here.
>
>>>>> @@ -2218,17 +2217,18 @@ static int hdmi_probe(struct platform_device *pdev)
>>>>> +
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4210-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4210;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4212-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4212;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos5250-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS5250;

But this way can make unnecessary combinations, e.g. exynos4210-hdmi + 
exynos5250-hdmi.

>>>> Instead of that, do roughly:
>>>>
>>>>      match = of_match_device(hdmi_match_types, &pdev->dev);
>>>>      if (match)
>>>>          hdata->version |= (int)match->data;
>>>>
>>>> That way, it's all table-based. Any future additions to
>>>> hdmi_match_types[] won't require another if statement to be added to
>>>> probe().
>>> I don't think it's that easy. of_match_device returns the first match
>>> from the device table, so I'd still need to iterate through the
>>> matches. I could still break this out into a table, but I don't think
>>> of_match_device is the right way to probe it.
>> You shouldn't have to iterate over multiple matches. of_match_device()
>> is supposed to return the match for the first entry in the compatible
>> property, then if there was no match, move on to looking at the next
>> entry in the compatible property, etc. In practice, I think it's still
>> not implemented quite correctly for this, but you can make it work by
>> putting the newest compatible value first in the match table.
> I think the only way that works is if you hardcode the compatible
> versions in the driver, like this:
>
> static struct of_device_id hdmi_match_types[] = {
>          {
>                  .compatible = "samsung,exynos5250-hdmi",
>                  .data = (void *)(HDMI_VER_EXYNOS5250 | HDMI_VER_EXYNOS4212);
>          }, {
>                  .compatible = "samsung,exynos4212-hdmi",
>                  .data = (void *)HDMI_VER_EXYNOS4212;
>          }, {
>                  .compatible = "samsung,exynos4210-hdmi",
>                  .data = (void *)HDMI_VER_EXYNOS4210;
>          }, {
>                  /* end node */
>          }
> };

I think this makes driver more clearly. We just see device tables and we 
can know device uses which version.

>
> In that case, it eliminates the benefit of using device tree to
> determine the compatible bits. I hope I'm just being thick and missing
> something.
>
> Sean
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

