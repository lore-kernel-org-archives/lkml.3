Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab3JQQwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:52:22 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:51338 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab3JQQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:52:17 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-69-526015c16b6d
Message-id: <526015BE.1020404@samsung.com>
Date: Thu, 17 Oct 2013 10:52:14 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/50] 3.11.6-stable review
References: <20131016174358.335646140@linuxfoundation.org>
In-reply-to: <20131016174358.335646140@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP92DoglBBq9WcVnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxf/5NloLbPBUzr71lb2Bs4upi5OCQEDCRePuGs4uRE8gUk7hwbz1bFyMXh5DAMkaJ
	7+e7oJxeJonN8+YwQzgbGSW6OzcxgrTwCmhJ3Lu3lBlkEouAqsT2GeUgYTYBdYnPr3ewg9hC
	AnISTUtWM4PYogIREiuXPGCFaBWU+DH5HguILSJgLNF/dhZYPbPAMUaJhc0mILYw0PiNrw4x
	Qsyxkpjaf4MJxOYUsJb4eOgtK0S9tcTKSdsYIWx5ic1r3jJD1CtL/Ll8igniSUWJ7autJjCK
	zEKyeRaS7llIuhcwMq9iFCstTi4oTkpPrTDUK07MLS7NS9dLzs/dxAiJl6odjHe+2hxiFOBg
	VOLhlfgZHyTEmlhWXJl7iFGCg1lJhLdVOCFIiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NFXfJR
	i0r7Mxvlz3cmdsd1MUWJivU8lLZ0evC10JYrfeLtPoktbVxCXkY98lmab5dM0NO/c+vaLzX/
	xIcXr+cVTGjh5ZfS4Fr6k19wU3qk0UQjVdU2eVO+RwvDdD+zfr10J+tRKIv8pinpa/fuE9r9
	THFd/Judfjv2Wqz5sKpYxcP5e21JthJLcUaioRZzUXEiAC3aSvR1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 11:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.6 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Oct 18 17:43:24 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.11.6

Patch applied cleanly - yes
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

alpha 	defconfig 	Passed 	Passed
arm 	defconfig 	Passed 	Passed
arm64 	defconfig 	Passed 	Passed
blackfin 	defconfig 	Passed 	Passed
c6x 	defconfig 	Passed 	Passed
mips 	defconfig 	Passed 	Passed
mipsel 	defconfig 	Passed 	Passed
powerpc 	Passed 	Passed
sh 	defconfig 	Passed 	Passed
sparc 	defconfig 	Passed 	Passed
tile 	defconfig 	Passed 	Passed

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
