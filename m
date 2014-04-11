Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaDKXrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:47:00 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21803 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbaDKXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:46:58 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-40-53487ef1b524
Message-id: <53487EEF.6070507@samsung.com>
Date: Fri, 11 Apr 2014 17:46:55 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 00/23] 3.14.1-stable review
References: <20140411161200.236939691@linuxfoundation.org>
In-reply-to: <20140411161200.236939691@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.215]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX91PdR7BBtMPsFrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujPaOSawFx9kq/hw7z97AOJO1i5GTQ0LAROLI7U3MELaYxIV769m6
	GLk4hASWMUq83H6VEcLpZZJ4dus1VGYbo0THhgVsIC28AloSh552go1iEVCVaP89lRHEZhNQ
	l/j8egc7iC0kICfRtGQ12ApRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3Uh2DZmgVWMEtcvLwdb
	IAx03+n+e8wQg6wk2lqWgS3gFLCW6JzbD2YzA9krJ22DsuUlNq95C1WvLPHn8ikmiN+UJe5c
	7macwCgyC8nuWUjaZyFpX8DIvIpRrLQ4uaA4KT21wlivODG3uDQvXS85P3cTIySaanYw3vtq
	c4hRgINRiYf3g4ZHsBBrYllxZe4hRgkOZiUR3rdZQCHelMTKqtSi/Pii0pzU4kOMTBycUg2M
	EjtKt0tdYdfcf8yqkvtj/Z11sneePH/MWNCsMYdpCnfADf8WsZUbjUKOLOY78d9u8ktHZedT
	fE4pUtl2dyTtC7UWTah/vIP/SUkvY8/l6V15tlU/U7foPjK3EnjEuiIiurH41vuC2z8r3hln
	zc9ZuaNFekO1g+HXUsHdcl0Nl6MXR2XncKxVYinOSDTUYi4qTgQAxWSx3IQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.1-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
