Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3K0WaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:30:02 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:46954 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab3K0W35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:29:57 -0500
X-AuditID: cbfec37a-b7f426d000003112-0a-52967264e020
Message-id: <52967261.7060806@samsung.com>
Date: Wed, 27 Nov 2013 15:29:53 -0700
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
Subject: Re: [PATCH 3.10 00/80] 3.10.21-stable review
References: <20131127005640.934155527@linuxfoundation.org>
In-reply-to: <20131127005640.934155527@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92UomlBBkvu6lrMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx5cAE9oK1nBUdDf+ZGxj3sncxcnJICJhIfF53jg3CFpO4cG89kM3FISSwjFHi8tFt
	jBBOL5PE/P+rWEGqhAQ2MUps+pYEYvMKaEnM+b0JLM4ioCpx4OQlZhCbTUBd4vPrHewQ9XIS
	TUtWg8VFBSIkjq5+xgrRKyjxY/I9FhBbRCBYYu3XhWDLmAVWMEocf/kS7CRhAVOJI/93MkMM
	spJ4ceg4WJxTwFri07fpYIOYgeyVk0AuBbHlJTaveQtVryzx5/Ippi5GDqDXFCW2r7aawCgy
	C8nqWUi6ZyHpXsDIvIpRrLQ4uaA4KT21wlCvODG3uDQvXS85P3cTIyRmqnYw3vlqc4hRgINR
	iYf3gOa0ICHWxLLiytxDjBIczEoivGr2QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MDZkRK2d5
	M6x8M7dM2eUZA8tRic8+EpVTP22Y+rJD9JEOh+G9t2uSXD65lAvEvH4tvHr998TeiAncgQL/
	13JJvdNfYZZptHe71Xle9sTajjVRwdPsZysvVHvrsWafuc6hLfamDzId7ksv1/T94DuDeb7L
	WQU3ubMRHyVT5vy7zd5QzM/2x/+iEktxRqKhFnNRcSIAIm9h1HcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 05:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.21 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:56:25 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.21-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed
Cross-compile testing - didn't test this time.

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
