Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaAXRii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:38:38 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28729 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaAXRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:38:37 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-32-52e2a51b8fdf
Message-id: <52E2A518.9030701@samsung.com>
Date: Fri, 24 Jan 2014 10:38:32 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, alan@linux.intel.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] staging/usbip: Add missing speeds to userspace
 speed_strings array
References: <1390420383-3933-1-git-send-email-shuah.kh@samsung.com>
 <alpine.DEB.2.10.1401241106380.28215@mint32-virtualbox>
 <52E29F04.2070106@samsung.com>
 <alpine.DEB.2.10.1401241129370.30747@mint32-virtualbox>
In-reply-to: <alpine.DEB.2.10.1401241129370.30747@mint32-virtualbox>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.10]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9hX13ppY+CDO48Mra48PwCi8WeM7/Y
	LZoXr2ezuLxrDpvFomWtzBbPruVYfP3pYPFl0ks2Bw6PJRfuMHnc23eYxWPnrLvsHvNOBnrs
	n7uG3ePzJrkAtigum5TUnMyy1CJ9uwSujJ33FjMWrOereLhgJmsD4y3uLkZODgkBE4me74dZ
	IGwxiQv31rN1MXJxCAksY5RoOHWACcLpZZK482MflLOJUWLtmXeMXYwcHLwCWhLrJ8iCmCwC
	qhKrzzKBDGITUJf4/HoHO4gtJCAn0bRkNTOILSoQIfHq7ESwZbwCghI/Jt8Ds0UE9CU2/DzH
	AjKeWeA+o8Szdc8YQRLCApESC/pOMUEMusEo8eF7KYjNKeAicbnnP1icWcBaYuWkbYwQtrzE
	5jVvmSHqlSX+XAbp5QD6TFHixUOrCYwis5CsnoWkexaS7gWMzKsYxUqLkwuKk9JTK4z1ihNz
	i0vz0vWS83M3MUKiqmYH472vNocYBTgYlXh4PwQ/DBJiTSwrrsw9xCjBwawkwrtq+qMgId6U
	xMqq1KL8+KLSnNTiQ4xMHJxSDYzzjf6+lLDbdpqxZbHaE8Gl/JfVKpee1CouLExXv8WlGBdy
	7Z1IpPqz1Ust1SZeFNsWuet05/sT+/Re/+8qe3uDy12kaOeT+Bl3735eIJzKFyyp7pq8mTH6
	4c3C5sWvrt/2d3uxrflvg9zhOW858p2+n9VcJfk3JGt/eeOjT6GMl+7NOc/+vt9JiaU4I9FQ
	i7moOBEAibIQoYgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 10:31 AM, Thomas Pugliese wrote:
>
>
> On Fri, 24 Jan 2014, Shuah Khan wrote:
>
>> On 01/24/2014 10:08 AM, Thomas Pugliese wrote:
>>>
>>>
>>> On Wed, 22 Jan 2014, Shuah Khan wrote:
>>>
>>>> Add speed strings for usb wireless and 3.0 to speed_strings array.
>>>>
>>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>>> ---
>>>>    drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>>>> b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>>>> index 66f03cc..8cb4fcc 100644
>>>> --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>>>> +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>>>> @@ -23,6 +23,8 @@ static const struct speed_string speed_strings[] = {
>>>>    	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
>>>>    	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
>>>>    	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
>>>> +	{ USB_SPEED_WIRELESS, "2.5", "Wireless"},
>>>> +	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
>>>>    	{ 0, NULL, NULL }
>>>>    };
>>>>
>>>> --
>>>
>>> Wireless USB supports variable speeds from 53.3Mbps to 480Mbps.  I'm not
>>> sure how you want to represent that but "2.5" doesn't seem to apply.
>>>
>>
>> Would "variable" be better suited in this case?
>>
>
> Sure.  You could also use something like "53.3-480" since that would more
> closely match the other entires which are numerical values in Mbps units.
>
> Thomas
>

"53.3-480" sounds good. I will send v2 with that change. Thanks for the 
review.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
