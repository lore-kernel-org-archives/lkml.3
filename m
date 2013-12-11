Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3LKBtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:49:01 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:16466 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LKBs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:48:59 -0500
X-AuditID: cbfec37d-b7f8d6d000001688-a0-52a7c48afd39
Message-id: <52A7C482.9070706@samsung.com>
Date: Tue, 10 Dec 2013 18:48:50 -0700
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
Subject: Re: [PATCH 3.4 00/25] 3.4.74-stable review
References: <20131210075930.808460227@linuxfoundation.org>
In-reply-to: <20131210075930.808460227@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX92uI8uDDM72a1nMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxduIFpoILnBWrN8xkbmA8xd7FyMkhIWAiMePKTyhbTOLCvfVsXYxcHEICyxgl3n/Y
	C+X0Mkk8OrqAGcLZyCixsqObDaSFV0BL4vWTQ2A2i4CqxJbmu0wgNpuAusTn1zvAxgoJyEk0
	LVnNDGKLCkRIHF39jBWiV1Dix+R7LCC2iECwxNqvCxlBFjALrGCUOP7yJdhQYQFjiXPL25gh
	BllJfJx2DKyBU8Ba4vuaSWALmIHslZO2MULY8hKb17yFqleW+HP5FNBBHEC/KUpsX201gVFk
	FpLVs5B0z0LSvYCReRWjWGlxckFxUnpqhYlecWJucWleul5yfu4mRkjU1O5gvP/V5hCjAAej
	Eg/vgaLlQUKsiWXFlbmHGCU4mJVEeDeaAoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwMnRWd9yZ
	tTA/Y5u2xdx9LxRK5Fo2f1ZwuhisfHhV5JtVt3Zx8xz9/ezSYbPLCR+5H76c8fzYlk/c0x+w
	nb/m8mQOX/naqvirdeUmnfq/00p6djQufP3qdNDVTSqPko78XLVXvzxtGRfj/AN7thtsWO51
	T0Op4/oMjjVn/9+7IZP/p8RJ4PjZGSxKLMUZiYZazEXFiQDlDufweAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.74 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Dec 12 07:59:15 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.74-rc1.gz
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

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
