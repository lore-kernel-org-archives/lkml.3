Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3K0W2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:28:39 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:42143 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3K0W2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:28:36 -0500
X-AuditID: cbfec37a-b7f426d000003112-b7-52967212f5e6
Message-id: <5296720F.9060404@samsung.com>
Date: Wed, 27 Nov 2013 15:28:31 -0700
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
Subject: Re: [PATCH 3.12 000/116] 3.12.2-stable review
References: <20131127005736.915454872@linuxfoundation.org>
In-reply-to: <20131127005736.915454872@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP12homlBBmc/q1rMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx9d16poKVnBVPX/9naWDczd7FyMkhIWAisfvlFBYIW0ziwr31bF2MXBxCAssYJT50
	HWaFcHqZJBqWPWeCcDYxSpxq3AbWwiugJbHi+TxWEJtFQFXixcp+RhCbTUBd4vPrHWArhATk
	JJqWrGYGsUUFIiSOrn7GCtErKPFj8j2wOSICwRJrvy5kBFnALLCCUeL4y5dsIAlhATOJO/9P
	AhVxAA2ykji8PxAkzClgLXFn9j+wXcxA9spJ26BseYnNa94yQ+xVlvhz+RQTSKuEgKLE9tVW
	ExhFZiHZPAtJ9ywk3QsYmVcxipUWJxcUJ6WnVhjqFSfmFpfmpesl5+duYoTETNUOxjtfbQ4x
	CnAwKvHwHtCcFiTEmlhWXJl7iFGCg1lJhFfNHijEm5JYWZValB9fVJqTWnyIkYmDU6qBMcam
	bdPxns+RS12OlCTe6Fz0Mcx1Kr9y/stLpZ0zXHSt2P8q55k1xDPp3fmgoB0wPc2TnflYfZSa
	B+P6B8sNDjR/49pz0rmt8zKvLcvMrzVXJnC9W/8zw79m3w6uM4srjDyYuhW/mYS5ZDLrp1VI
	d5xQdIoNfSBUEh+8N/dI0Kbl1x0WJn9UYinOSDTUYi4qTgQA2Zuh7XcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 05:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.2 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:57:18 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

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
