Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3JKHGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:06:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23459 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3JKHGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:06:18 -0400
X-AuditID: cbfee68e-b7f756d000004512-6d-5257a3687ee4
Message-id: <5257A36D.80902@samsung.com>
Date: Fri, 11 Oct 2013 16:06:21 +0900
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
In-reply-to: <5257977C.1030108@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWyRsSkQDdjcXiQwfHlBhbzj5xjtejf4mJx
	7tVKRosLT3vYLJbuW81isbBtCYvF5V1zgNzrF5ksbjeuYLOYMH0ti8XhFQeYLNa9nM5icWN6
	C6vFq4NtLA58HmvmrWH0WPD5CrvHyuVf2DxerZ7J6tHb/I7No2/LKkaPqVP+Mnocv7GdyePz
	JjmPjXNDA7iiuGxSUnMyy1KL9O0SuDLuvdrAVrCIveLGqtVMDYwfWbsYOTkkBEwk3i1pgLLF
	JC7cW8/WxcjFISSwlFFi662bQAkOsKLzO5Ig4osYJS7+2sAO4bxilLh+4QELSDevgIZES+Nn
	dhCbRUBVYu7/r0wgNpuAlsT+FzfYQGxRgTCJldOvQNULSvyYfA/MFgGqOb3zBzPIUGaBRawS
	e7/PZgZJCAtESkzeN5Md5AohgXKJ/82yIGFOATWJLX++gZUwC+hI7G+dxgZhy0tsXvMWbI6E
	wEoOiXlTvrNCHCQg8W3yIRaIb2QlNh1ghvhYUuLgihssExjFZiE5aRaSsbOQjF3AyLyKUTS1
	ILmgOCm9yEivODG3uDQvXS85P3cTIzDWT/971reD8eYB60OMyUArJzJLiSbnA1NFXkm8obGZ
	kYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY5+t+sxGOZHu2
	3JB1ysPs3AZR3fMHb634ueFuxYdMs0Xb1u9vzDR9IP5NyGuejObXNe9nW4q7TkiUDbr37/Ha
	V7Hr1CzNN15cH/GtLXL1Mr7fgcITn83ZVG/ybEHJWaHOuyHBZonJOVb3nz9lCL/65bLk5GNn
	S388DGfaXGVb+Wb5418nWKef4FZiKc5INNRiLipOBACYuy4cCwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd2MxeFBBrMOqlrMP3KO1aJ/i4vF
	uVcrGS0uPO1hs1i6bzWLxcK2JSwWl3fNAXKvX2SyuN24gs1iwvS1LBaHVxxgslj3cjqLxY3p
	LawWrw62sTjweayZt4bRY8HnK+weK5d/YfN4tXomq0dv8zs2j74tqxg9pk75y+hx/MZ2Jo/P
	m+Q8Ns4NDeCKamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYce/VBraCRewV
	N1atZmpg/MjaxcjBISFgInF+R1IXIyeQKSZx4d56ti5GLg4hgUWMEhd/bWCHcF4xSly/8IAF
	pIpXQEOipfEzO4jNIqAqMff/VyYQm01AS2L/ixtsILaoQJjEyulXoOoFJX5MvgdmiwDVnN75
	gxlkKLPAIlaJvd9nM4MkhAUiJSbvm8kOcpGQQLnE/2ZZkDCngJrElj/fwEqYBXQk9rdOY4Ow
	5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAieSa9
	g3FVg8UhRgEORiUeXguG8CAh1sSy4srcQ4wSHMxKIrz75gOFeFMSK6tSi/Lji0pzUosPMSYD
	Q2Ais5Rocj4wyeWVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	AyPvpmN/zViTD6zr3jY9Oyxj1fTubV7MfYtrD//ZxrFo4xPuCgZnzXlbCrcXTuOo6bp2nH33
	LkXL229Pp4Ye/Sji+eTstUtcxqtyLaQCnh2e0a90zzpCMvzpQYbst1HLZuiIfvdecfDUIxsp
	l0VqUp9ub7L+9sGzZ/nLy0vjDprXn2p8nLP+4L5XSizFGYmGWsxFxYkA0kBj2mgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 03:15 PM, Kishon Vijay Abraham I wrote:
> On Thursday 10 October 2013 06:41 PM, Laxman Dewangan wrote:
>> On Thursday 10 October 2013 06:07 PM, Kishon Vijay Abraham I wrote:
>>> The Palmas device contains only a USB VBUS-ID detector, so added a
>>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>>> types for backward compatibility.
>>>
>> I dont have much issue on this nomenclature but just second thought:
>>
>> The Palmas USB module is capable of detection VBUS, ID-GND, ID-RA, ID-RB, ID-RC
>> and ID-FLOAT as per BC1.2.
>> This sub-module only detect the cable, does nothing more than this.
>> In this case, should we say "ti,palmas-usb-extcon"?
>> Again extcon is linux specific terminology and this can be defer.
> 
> I don't mind either way. Chanwoo?

The EXTCON is subsystem name. I don't prefer to use 'extcon' word on device name.
I agree Kishon opinion.

