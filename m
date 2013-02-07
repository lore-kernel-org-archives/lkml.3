Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3BGDh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:37:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13416 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab3BGDhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:37:55 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fb06d000000f28-a9-5113219181c6
Content-transfer-encoding: 8BIT
Message-id: <5113218D.9040304@samsung.com>
Date: Thu, 07 Feb 2013 12:37:49 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130206130615.86121923.akpm@linux-foundation.org>
 <511306BB.2020708@samsung.com>
 <20130206182817.3af25596.akpm@linux-foundation.org>
In-reply-to: <20130206182817.3af25596.akpm@linux-foundation.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zHd2JisKBBre6ZS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpFm32AuWsFfcOX6UvYHxNWsXIyeHhICJxIvPOxghbDGJC/fW
	s3UxcnEICSxjlNj18R4LTNHbubNZIRKLGCWunT7IBJLgFRCU+DEZpIiDg1lAXuLIpWyQMLOA
	usSkeYuYIeq7mCTaLs5jhKjXkniz7g0ziM0ioCrx694csDibgJzE26ZvjCBzRAUiJH71c4CE
	RQR0JVY938UMMTNE4snCE2wgtrCAncSeaQug5l9llLi78g/YHE4BB4m3U46wgyQkBNrZJS7+
	3sICsUxA4tvkQ2CHSgjISmw6wAzxmKTEwRU3WCYwis1C8s4shHdmIXlnASPzKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYyQiJDewbiqweIQowAHoxIP782lQoFCrIllxZW5hxglOJiVRHiz
	nwKFeFMSK6tSi/Lji0pzUosPMSYD3TeRWUo0OR8YrXkl8YbGBsaGhpaGZqaWpgakCSuJ8zKe
	ehIgJJCeWJKanZpakFoEs4WJg1OqgXHSv8wviwUEyzizHRkW3DfZzrbih6743X9XHnz58TVg
	/nFBdy8n43ubGtdX5ys7/9rz/Tg/c4ca+7kjpXrcLL3Zi38dbr36vWlHDl99tpPtWv4vZ6cV
	ZVS3fA2ZbWU5c4LFXkWRXqF3UgIvrBwD2JZufX4+6ey3OvNAJXfOxsRPbNatQjIsj5RYijMS
	DbWYi4oTAbev/yPMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd2JisKBBo3/xSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqRZt9gLlrBX3Dl+lL2B
	8TVrFyMnh4SAicTbubOhbDGJC/fWs3UxcnEICSxilLh2+iATSIJXQFDix+R7LF2MHBzMAvIS
	Ry5lg4SZBdQlJs1bxAxR38Uk0XZxHiNEvZbEm3VvmEFsFgFViV/35oDF2QTkJN42fWMEmSMq
	ECHxq58DJCwioCux6vkuZoiZIRJPFp5gA7GFBewk9kxbADX/KqPE3ZV/wOZwCjhIvJ1yhH0C
	o8AsJOfNQjhvFpLzFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjrdn0jsYVzVYHGIU
	4GBU4uG9uVQoUIg1say4MvcQowQHs5IIb/ZToBBvSmJlVWpRfnxRaU5q8SHGZKDnJjJLiSbn
	A1NBXkm8obGJmZGlkZmxibmxMWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpg7Bfwb7bN
	EdpQveJtu6uDvfiMaFa9R3LTLD6Z6TPsmGBdGyS4JnfBLelYr+AZUUE17/6GVPcFsCftsnk9
	SdRQOUBzsvgkAZ+0Z4cf+v+SnzBBfNelbA65ObU1/7ffSGZiesh1X0bnx+l5+mECcxhfacnr
	a0dftFkTaBiU+v/mbAbuNSecP/9SYinOSDTUYi4qTgQAqLcMt/sCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 07일 11:28, Andrew Morton wrote:
> On Thu, 07 Feb 2013 10:43:23 +0900 jonghwa3.lee@samsung.com wrote:
> 
>>> The best way of handling this sort of thing is for the driver to probe
>>> the hardware, work out its capabilities and "do the right thing".
>>>
>>> The second best way is to require that the user add certain module
>>> parameters to enable the functionality.
>>>
>>
>> How do we create sysfs node for enabling these options?
> 
> I suggest using module_param[_named](), so users can execute "modprobe
> max8997 wtsr=1".  Or, if the driver is built into vmlinux, add
> "max8997.wtsr=1" to the kernel boot command line.
> 
> Documentation/kernel-parameters.txt mentions this.
> 
Sorry, my question was incorrect, I meant to suggest to create sysfs node not to
ask you to let me know how to implement sysfs node. Anyway I'll apply your
comment and re-patch it soon.

Thanks,
Jonghwa
