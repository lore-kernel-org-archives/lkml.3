Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3KTP0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:26:14 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:39667 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:26:09 -0500
X-AuditID: cbfec37a-b7fb76d000006e93-b0-528cd48fcca0
Message-id: <528CD47F.8070006@samsung.com>
Date: Wed, 20 Nov 2013 08:25:51 -0700
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
Subject: Re: [PATCH 3.12 00/19] 3.12.1-stable review
References: <20131118183644.030738675@linuxfoundation.org>
In-reply-to: <20131118183644.030738675@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX93+Kz1BBo/u2FjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx64VfwTWuihMX/zI1MB7l6GLk5JAQMJE4OecbE4QtJnHh3nq2LkYuDiGBZYwSd869
	YoFwepkkrn6Yzw7hbGKUmPXpHQtIC6+AlsS+A/OZQWwWAVWJ/Tu2s4PYbALqEp9f7wCzhQTk
	JJqWrAarERWIkDi6+hkrRK+gxI/J98DmiAgES6z9upARZAGzwApGieMvX7KBJISB7ju3+DQL
	xCAriXmn/4MN4hSwlng6dTtYDTOQvXLSNkYIW15i85q3zBD1yhJ/Lp8C+o0D6DdFie2rrSYw
	isxCsnoWku5ZSLoXMDKvYhQrLU4uKE5KT60w1CtOzC0uzUvXS87P3cQIiZmqHYx3vtocYhTg
	YFTi4S1Y1B0kxJpYVlyZe4hRgoNZSYS3a29PkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGQiHz
	n8InSq/MuvV/Pfthbt5gncotnsftbi8UKYhM57wdZtTwTTmke+OMPzN6+15ff13Ec4Tvx4kd
	6reaPUpvyOj48exiyfK01WA032ClrOTBMHWF7/uWFZZXm9ekNJ18JKr9Ttrk94z9t5+t2XqO
	rffH4bIpRdPT+dlrV3yd0ltW6/1n3hw7JZbijERDLeai4kQAMeayuncCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.1 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Nov 20 18:36:14 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.1-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.12.1:

patches applied cleanly
Compile test - passed
Boot tests - passed

dmesg regression tests - passed
[dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.]

Cross-compile testing - limited tests passed (alpha, arm, arm64, 
blackfin, c6x, powerpc, sh, sparc, tile)

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
