Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3IZCWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:22:40 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:32375 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3IZCWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:22:38 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-08-52439a6c13cc
Message-id: <52439A60.3080501@samsung.com>
Date: Wed, 25 Sep 2013 20:22:24 -0600
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
Subject: Re: [ 00/28] 3.0.97-stable review
References: <20130925000648.404447782@linuxfoundation.org>
In-reply-to: <20130925000648.404447782@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP92cWc5BBrsmKlnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXxfJFDwVOeis2bVrE1ME7l6mLk5JAQMJH4fnczG4QtJnHh3nogm4tDSGAZo8SWrxMY
	IZxeJolL5/YwQzibGCUO354LlOHg4BXQkrg42R2km0VAVWLH6VUsIDabgLrE59c72EFsIQE5
	iaYlq5lBbFGBCImVSx6wgti8AoISPybfA6sXETCW6D87C6yeWeAYo8TCZhMQWxho/ON/TSwQ
	c6wk5jT9BruUU8Ba4uPxnUwQ9dYSKydtY4Sw5SU2r3nLDFGvLPHn8ikmkDMlBBQltq+2msAo
	MgvJ5llIumch6V7AyLyKUay0OLmgOCk9tcJIrzgxt7g0L10vOT93EyMkXqp3MN79anOIUYCD
	UYmHV+G/U5AQa2JZcWXuIUYJDmYlEd5vRs5BQrwpiZVVqUX58UWlOanFhxiZODilGhhnVO3Y
	Idfk3cxZeyZ3rXqYz96zvFO67yuc9WmY8ndZxyK9AH5V63LrxS93/f54qW4z79pVk+TMHigl
	31jqIbZwYvpD0+xnJ+8v7La9IbW6Wc9G5b/yuSvFXgl5HlxMxt+Pyib2vAmvTzxQU9izSELg
	XKvVk4Q53FrqF08ICKc8ed65Tfaa1kslluKMREMt5qLiRACF8uSidQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.97 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep 27 00:05:34 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.97-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.0.97-rc1 applied with the following warning from line 103 to 3.0.96

patch-3.0.97-rc1:103: space before tab in indent.
                         return -1;
warning: 1 line adds whitespace errors.

Compiled and booted on the following systems:

HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: not applicable
blackfin: defconfig passed
c6x: not applicable
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
