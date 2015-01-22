Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbbAVMB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:01:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13328 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbAVMB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:01:28 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ec-54c0e6051e36
Message-id: <54C0E692.7000806@samsung.com>
Date: Thu, 22 Jan 2015 15:01:22 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH] rtc: s5m: terminate s5m_rtc_id array with
 empty element
References: <1421852809-29733-1-git-send-email-a.ryabinin@samsung.com>
 <CAJKOXPfuxD91=hEYoTQ2Vdes+cf-FXGUZRD2HUbeNzS3czKobA@mail.gmail.com>
In-reply-to: <CAJKOXPfuxD91=hEYoTQ2Vdes+cf-FXGUZRD2HUbeNzS3czKobA@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xK7qszw6EGOw8z2Kx5OJVdovXLwwt
	Lu+aw2axv7OD0YHFY8/Ek2wefVtWMXpMn/eTyePzJrkAligum5TUnMyy1CJ9uwSujGu/igou
	sFa03HnP3sB4gqWLkZNDQsBEYuO7P8wQtpjEhXvr2boYuTiEBJYySnw/OI0Jwmlmkjj+ZzpY
	Fa+AlsSilZPZQGwWAVWJh6/62EFsNgE9iX+ztoPFRQUiJD6s+soGUS8o8WPyPbBtIgK+Eg9W
	HgWzmQU8Jc50PgGzhQWiJM6d+sIOsayXUWJO4xLWLkYODk6BYImtbyNATGYBdYkpU3IhWuUl
	Nq95yzyBUWAWkg2zEKpmIalawMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkbL/sYFx8
	zOoQowAHoxIPb8DKAyFCrIllxZW5hxglOJiVRHi33QcK8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YKyVjDM0ex6+zefh6s8VTMdf7Fx/Plhlz32+7Mga/gNmi4Q11lawydb99Vf7rcdrey35Om9z
	ac7SYr6nf3VtYzkeNReemZsVxz0vb73q58ePXU22tuYzM3qn3eI60Gv1ea4gy4xzt358mr6l
	4c/lhRdkU0vOcIsYNlivSnytuczR7ubnvIwd7UosxRmJhlrMRcWJAGv+Dvk5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 12:37 PM, Krzysztof Kozlowski wrote:
> 2015-01-21 16:06 GMT+01:00 Andrey Ryabinin <a.ryabinin@samsung.com>:
>> Array of platform_device_id elements should be terminated
>> with empty element.
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  drivers/rtc/rtc-s5m.c | 1 +
>>  1 file changed, 1 insertion(+)
> 
> 
> Right, good catch.
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Maybe also cc stable for fixing 5bccae6ec458 ("rtc: s5m-rtc: add
> real-time clock driver for s5m8767")?
> 

Probably. I didn't add stable tag because, I have no idea what are runtime
effects of this bug, so I don't know whether this worth for stable or not.

