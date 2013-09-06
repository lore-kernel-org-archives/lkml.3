Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab3IFRgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:36:53 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36392 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3IFRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:36:51 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-bf-522a12b1bb69
Message-id: <522A12AE.2090600@samsung.com>
Date: Fri, 06 Sep 2013 11:36:46 -0600
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
Subject: Re: [ 00/36] 3.10.11-stable review
References: <20130905202702.289738686@linuxfoundation.org>
In-reply-to: <20130905202702.289738686@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92NQlpBBouWqlnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXR+/AiY8FO3op1066yNjC+5upi5OSQEDCRaH36hhnCFpO4cG89WxcjF4eQwDJGidML
	OxghnF4mif4189khnM2MEv9WHQJr4RXQknh1+hcjiM0ioCrx9c1ONhCbTUBd4vPrHewgtpCA
	nETTktVg9aICERIrlzxghegVlPgx+R4LiC0iYCzRf3YWWD2zwDFGiYXNJiC2sIC2xK2+c8wQ
	c6wkJry+CzafU8Ba4tLbP6wQ9dYSKydtY4Sw5SU2r3kLVa8s8efyKaYuRg6g1xQltq+2msAo
	MgvJ5llIumch6V7AyLyKUay0OLmgOCk9tcJIrzgxt7g0L10vOT93EyMkZqp3MN79anOIUYCD
	UYmH1+C2ZpAQa2JZcWXuIUYJDmYlEd4zDFpBQrwpiZVVqUX58UWlOanFhxiZODilGhhZdvw4
	sXX9lfyl+v/WrNm8X3W2snLdwvQH75eduPt87/4NwrMuJfVHbHlz+5/ArXzx5Fu7Mm8cXFj+
	nvuxrPUUTcs+T273W+fUjY6xfznWsIFb0f+4Quzd6c6CdfMsb/3qea3koDnbWfPppI4rYeXl
	+90frAuIfnp84jLJ5Yk6/w0X++1amM0qp8RSnJFoqMVcVJwIAIVXl7N3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 02:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.11 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.11-rc1 applied cleanly to 3.10.10

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Compile tested on Samsung Chromebook Exynos5 (ARMv7):
Note: Hoping to run boot tests on this new test system, but I was able 
to compile the 3.10.11-rc1 on this system running Ubuntu 13.04 so far.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
blackfin: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
