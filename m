Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3H0UlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:41:01 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10959 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3H0Uk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:40:59 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-83-521d0ed956d0
Message-id: <521D0ED6.30301@samsung.com>
Date: Tue, 27 Aug 2013 14:40:54 -0600
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
Subject: Re: [ 0/9] 3.0.94-stable review
References: <20130827010251.636183797@linuxfoundation.org>
In-reply-to: <20130827010251.636183797@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX92bfLJBBi/PWVjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxeHsPY0E7T8WHb74NjLc5uxg5OSQETCS6ew+xQNhiEhfurWfrYuTiEBJYxigx51Y7
	M4TTyyTxqfssK4SzmVGi58J9JpAWXgENiQmbTzOD2CwCqhKnnp4Ei7MJqEt8fr2DHcQWEpCT
	aFqyGqxGVCBCYuWSB6wQvYISPybfA1stImAs0X92Flg9s8AxRomFzSYgtjDQ/KU/TwD1cgDN
	sZLo/iEBEuYUsJaYde4eI0S5tcTKSdugbHmJzWveMkOsVZb4c/kUE0irhICixPbVVhMYRWYh
	WTwLSfcsJN0LGJlXMYqVFicXFCelp1YY6xUn5haX5qXrJefnbmKExEvNDsZ7X20OMQpwMCrx
	8FpslgkSYk0sK67MPcQowcGsJMJb8h8oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdH077nzs5aL
	bTlkxGrXyP53p/2PL5cnRalHbX/l/Trj4JunS/qUDDm1n4h8Dpsn+jvxcMG6DXFPPqZkXavo
	rp8adc9NkaGo++MryY5f1mKVRS/Uoq3bxYWfrm01Yrhi/X35QoaHW0zK/ynd25S77ovFgh3N
	OY7FjQXLy14uZZvbGsUpavrfk0+JpTgj0VCLuag4EQDNAEjxdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 07:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.94 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 29 01:02:44 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.94-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

3.0.94
------
3.0.94-rc1 applied cleanly to 3.0.93

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
