Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3JKIXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:23:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40770 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab3JKIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:23:13 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-3c-5257b5709616
Message-id: <5257B576.3060800@samsung.com>
Date: Fri, 11 Oct 2013 17:23:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v6] extcon: palmas: Added a new compatible type
 *ti,palmas-usb-vid*
References: <1381408647-24653-1-git-send-email-kishon@ti.com>
 <5256A773.6060807@nvidia.com> <5257977C.1030108@ti.com>
 <5257A36D.80902@samsung.com> <5257AE43.4020902@ti.com>
In-reply-to: <5257AE43.4020902@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWyRsSkULdga3iQwbX3mhbzj5xjtejf4mJx
	7tVKRosLT3vYLJbuW81isbBtCYvF5V1zgNzrF5ksbjeuYLOYMH0ti8XhFQeYLNa9nM5icWN6
	C6vFq4NtLA58HmvmrWH0WPD5CrvHyuVf2DxerZ7J6tHb/I7No2/LKkaPqVP+Mnocv7GdyePz
	JjmPjXNDA7iiuGxSUnMyy1KL9O0SuDLO/JvDVLCcs6L3zFfWBsY97F2MnBwSAiYSMz8uZ4aw
	xSQu3FvP1sXIxSEksJRRYuuDtYwwRe0H5rFCJKYzSsy6v5AFwnnFKPH99DoWkCpeAS2JVQ8e
	soHYLAKqElt/9oDZbEDx/S9ugNmiAmESK6dfgaoXlPgx+R6YLQJUc3rnD2aQocwCi1gl9n6f
	DXaTsECkxOR9M9khtm1glPjz+yZQBwcHp4CaxLMVQiA1zAI6Evtbp7FB2PISm9e8BRskIbCU
	Q2LRnfnMEBcJSHybfAisV0JAVmLTAaifJSUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5IL
	ipPSiwz1ihNzi0vz0vWS83M3MQLj/fS/Z707GG8fsD7EmAy0ciKzlGhyPjBd5JXEGxqbGVmY
	mpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8R6voPiet1tPtHXc
	WJS1mPHwtABZ5Y+FFcc2u7iyFcgVTVzw79a8ZVeS3DufijhwTeO6cKX9W+8ZtkdJdqGP4oql
	FYK4xH52+lSIqey673/j6QXP+D3eF6TrfOK21e64UOKkKD7FaMH90NDJG2drTf/Tls7kqfzX
	9+0xoYaMw8wHp9deYAtwUWIpzkg01GIuKk4EAARR3M4NAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd2CreFBBgcXKVrMP3KO1aJ/i4vF
	uVcrGS0uPO1hs1i6bzWLxcK2JSwWl3fNAXKvX2SyuN24gs1iwvS1LBaHVxxgslj3cjqLxY3p
	LawWrw62sTjweayZt4bRY8HnK+weK5d/YfN4tXomq0dv8zs2j74tqxg9pk75y+hx/MZ2Jo/P
	m+Q8Ns4NDeCKamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcebfHKaC5ZwV
	vWe+sjYw7mHvYuTkkBAwkWg/MI8VwhaTuHBvPVsXIxeHkMB0RolZ9xeyQDivGCW+n17HAlLF
	K6AlserBQzYQm0VAVWLrzx4wmw0ovv/FDTBbVCBMYuX0K1D1ghI/Jt8Ds0WAak7v/MEMMpRZ
	YBGrxN7vs5lBEsICkRKT981kh9i2gVHiz++bQB0cHJwCahLPVgiB1DAL6Ejsb53GBmHLS2xe
	85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4GTyTHoH46oG
	i0OMAhyMSjy8FgzhQUKsiWXFlbmHGCU4mJVEePfNBwrxpiRWVqUW5ccXleakFh9iTAYGwURm
	KdHkfGCiyyuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRq7I
	3s+FLjtmzri8di+zpunT0E3Jn18+3ng9+t0+/qkZz37/b73EenK6T3H3uo4sTb78KW9v+IS+
	M/i1N6X6TUK24t7fT+Lvz/DUZ23WMNdj3Se8/9C85yfETv2Xvl+5rbfi8NXDGmsOmWhZbfpd
	svn0Z009r43WH4wUH2o4pN3gnyo17WGNdqcSS3FGoqEWc1FxIgBFHOyeagMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 04:52 PM, Kishon Vijay Abraham I wrote:
> Hi Chanwoo,
> 
> On Friday 11 October 2013 12:36 PM, Chanwoo Choi wrote:
>> On 10/11/2013 03:15 PM, Kishon Vijay Abraham I wrote:
>>> On Thursday 10 October 2013 06:41 PM, Laxman Dewangan wrote:
>>>> On Thursday 10 October 2013 06:07 PM, Kishon Vijay Abraham I wrote:
>>>>> The Palmas device contains only a USB VBUS-ID detector, so added a
>>>>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>>>>> types for backward compatibility.
>>>>>
>>>> I dont have much issue on this nomenclature but just second thought:
>>>>
>>>> The Palmas USB module is capable of detection VBUS, ID-GND, ID-RA, ID-RB, ID-RC
>>>> and ID-FLOAT as per BC1.2.
>>>> This sub-module only detect the cable, does nothing more than this.
>>>> In this case, should we say "ti,palmas-usb-extcon"?
>>>> Again extcon is linux specific terminology and this can be defer.
>>>
>>> I don't mind either way. Chanwoo?
>>
>> The EXTCON is subsystem name. I don't prefer to use 'extcon' word on device name.
>> I agree Kishon opinion.
> 
> Cool.. can you this patch as-is?
> 

OK, applied it.

Thanks,
Chanwoo Choi

