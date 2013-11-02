Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3KBVdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:33:20 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:37359 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3KBVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:33:18 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-b2-52756f9dfea1
Message-id: <52756F9B.6010400@samsung.com>
Date: Sat, 02 Nov 2013 15:33:15 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/32] 3.4.68-stable review
References: <20131101214313.735463599@linuxfoundation.org>
In-reply-to: <20131101214313.735463599@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX925+aVBBtdPm1rMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXxbvJGloJO7ooLdzczNTBe4+hi5OSQEDCRWHdkEwuELSZx4d56ti5GLg4hgWWMEmvv
	H2CHcHqZJGZdn8sE4WxilNi7cz1YC6+AlsSmecfZQWwWAVWJ1Q19bCA2m4C6xOfXO8DiQgJy
	Ek1LVjOD2KICERJHVz9jhegVlPgx+R7YHBGBYIm1XxcygixgFljBKHH85UuwQcJAC27/uMsC
	MchKYsGMvWA2p4C1xOptT8CGMguYSTxqWQdly0tsXvOWGaJeWeLP5VNAV3MA/aYosX211QRG
	kVlIVs9C0j0LSfcCRuZVjGKlxckFxUnpqRWGesWJucWleel6yfm5mxghUVO1g/HOV5tDjAIc
	jEo8vJ78JUFCrIllxZW5hxglOJiVRHjl/EqDhHhTEiurUovy44tKc1KLDzEycXBKNTA2M+w1
	YN/kxb4mYFu96ccn6yenidvOtFbm0pxYwKz9zKnxAvMZa27Vm0y3EjZ+S+mucGGwLL/96Edz
	/50t70LWf6+auegN51rb0uBHQl1TLsz0m3LT7z7zvbJpD7SnvNta+uzBkjIrrztpay6n/pxs
	u6hVvVZPuaBG8orwXNX1hx+c4HX1XsivxFKckWioxVxUnAgA4XISLXgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 03:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.68 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Nov  3 21:41:40 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.68-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Release 3.4.68	

Patch applied cleanly	yes
Compile test		passed
Boot test		passed
dmesg regression test	passed
Cross-compile test	passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Architecture 	Config 		3.4.68
alpha 		defconfig 	Passed
arm 		defconfig 	Passed
arm64 		defconfig 	Passed
blackfin 	defconfig 	Passed
c6x 		dsk6455_defconfig 	Passed
mips 		defconfig 	Passed
mipsel 		defconfig 	Passed
powerpc 	wii_defconfig 	Passed
sh 		defconfig 	Passed
sparc 		defconfig 	Passed
tile 		tilegx_defconfig 	Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
