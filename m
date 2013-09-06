Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab3IFRrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:47:08 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:27441 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3IFRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:47:06 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-28-522a15177d23
Message-id: <522A1515.8090300@samsung.com>
Date: Fri, 06 Sep 2013 11:47:01 -0600
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
Subject: Re: [ 00/14] 3.4.61-stable review
References: <20130905202614.354156084@linuxfoundation.org>
In-reply-to: <20130905202614.354156084@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP11xUa0gg+VvpS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrYeL6HqeA4X8WnGUUNjE+4uxg5OSQETCTW/FrGBGGLSVy4t56ti5GLQ0hgGaNE76/5
	zBBOL5PEtv1/oZzNjBLvNpxgBmnhFdCSeLbpEzuIzSKgKnHn6ipWEJtNQF3i8+sdYHEhATmJ
	piWrwepFBSIkVi55wArRKyjxY/I9FhBbRMBYov/sLLB6ZoFjjBILm01AbGGg+a/fzmSDmGMl
	sXTlHrAaTgFriSu/9jJC1FtLrJy0DcqWl9i85i0zRL2yxJ/Lp4Be4wB6TVFi+2qrCYwis5Bs
	noWkexaS7gWMzKsYxUqLkwuKk9JTKwz1ihNzi0vz0vWS83M3MUIipmoH452vNocYBTgYlXh4
	DW5rBgmxJpYVV+YeYpTgYFYS4T3DoBUkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbHCsb76Asey
	pa9Edu/jFJGOrfu8ZnJeBrfE9utTxBsCOAx+fU2aavFy2pQL73KZ+bc/XD+1rs3as+Biyxbu
	fQ1Gix3sb/9Tl2w9+iJ5vsyMLRe2ck9fymPyqKerkWuxpJaYmN3LD3GXTlx5UsDV8izP/bhr
	4FFpr+Q7vzaGOOsfqP28+O25k7uUWIozEg21mIuKEwFxYICxdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.61 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------


3.4.61-rc1 applied cleanly to 3.4.60

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Compile tested on Samsung Chromebook Exynos5 (ARMv7):
3.4.60 compile fail - it is not a regression. Existing issue in 3.4.y It 
has to do with missing config selections in arch/arm/mach-exynos/Kconfig 
for this system. Debugging now using the Kconfig selections from 3.10.y 
for this file.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: not applicable
blackfin: defconfig passed
c6x: dsk6455_defconfig passed - defconfig isn't supported
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
