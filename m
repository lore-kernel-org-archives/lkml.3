Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3IZC0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:26:15 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64554 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZC0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:26:13 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-d9-52439b441c84
Message-id: <52439B43.4000909@samsung.com>
Date: Wed, 25 Sep 2013 20:26:11 -0600
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
Subject: Re: [ 000/117] 3.11.2-stable review
References: <20130925001740.833541979@linuxfoundation.org>
In-reply-to: <20130925001740.833541979@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP12X2c5BBo9umlrMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVx6swlloKn3BV9K7axNjAe4Oxi5OSQEDCRODX7CTuELSZx4d56ti5GLg4hgWWMEl+6
	77NDOL1MEm8WnQarEhLYxChxqdUMxOYV0JKY93YeG4jNIqAqceHRLDCbTUBd4vPrHVD1chJN
	S1Yzg9iiAhESK5c8YIXoFZT4MfkeC4gtImAs0X92Flg9s8AxRomFzSYgtrCAjsSsDUsYIeZY
	SbQ0Xwaq5+DgFLCWeHw3DqLcTOJRyzpmCFteYvOat8wQ5coSfy6fYgIplxBQlNi+2moCo8gs
	JItnIemehaR7ASPzKkax0uLkguKk9NQKE73ixNzi0rx0veT83E2MkHip3cF4/6vNIUYBDkYl
	Ht4Lfs5BQqyJZcWVuYcYJTiYlUR4vxkBhXhTEiurUovy44tKc1KLDzEycXBKNTAyXvuaFhdf
	+T5cSf83y+9JDa8WvGGR1/9R2MFlMV1qns7x6ZmSE712ivb3XtE/O8FqovmmfzsfGBvFHI7n
	XvnX/tadyly9vTteelzb986T4X75i4J5SzV91JeuNJ3dOnfu9SvqQUU/XPS+5Dxo2eCUEbd4
	/ZwQtczJ1W3FCesWLL1bXK2Q8nWmEktxRqKhFnNRcSIAVUlKznUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.2 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep 27 00:16:31 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.11.2-rc1 applied cleanly to 3.11.1

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

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
tile: defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
