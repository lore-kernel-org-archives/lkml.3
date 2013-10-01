Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3JATXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:23:31 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:45530 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JATX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:23:29 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-ab-524b213081ed
Message-id: <524B212E.3020006@samsung.com>
Date: Tue, 01 Oct 2013 13:23:26 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/71] 3.11.3-stable review
References: <20130929192643.539596256@linuxfoundation.org>
In-reply-to: <20130929192643.539596256@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX11DRe8gg9ZWZos569ewWTQvXs9m
	cXnXHDaLrz8dLBZsfMRo8ajvLbsDm8fOWXfZPU7M+M3isX/uGnaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKWLtzEXPCEu2LFhzbGBsZ9nF2MnBwSAiYSjy60skPYYhIX7q1n62Lk4hASWMYo0dG7
	ihXC6WWSWLxiChOEs5FR4tvCWSxdjBwcvAJaEruX6oN0swioShz48JEJxGYTUJf4/HoH2FQh
	ATmJpiWrmUFsUYEIiZVLHrCC2LwCghI/Jt9jAbFFBIwl+s/OYgeZzyzwkFFi9sHXjCAJYaD5
	d65eYIMYZCVxtfEKM8heTgFriQULNUHCzAJmEo9a1jFD2PISm9e8ZYYoV5b4c/kUE0i5hICi
	xPbVVhMYRWYh2TwLSfcsJN0LGJlXMYqVFicXFCelp1YY6hUn5haX5qXrJefnbmKEREzVDsY7
	X20OMQpwMCrx8B645xUkxJpYVlyZe4hRgoNZSYS3l987SIg3JbGyKrUoP76oNCe1+BAjEwen
	VAOj0oLlpjGxzOLTf1368zq3NeLi2jStpYX3tpzOmXlw4xFWN1eR656PNSdtYTq08eSU606/
	OrcumHPIV8v/zqUy/jPpxctTdndwhIn7daxOW9LRFmZx5ffi5XKm2meur3U1/ckYNuXvYYeY
	/uNJs4RizZ17UvyeLN4lIvLMTGL/75Tz0/OF7gguV2Ipzkg01GIuKk4EAEo89Gt2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 01:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:26:27 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.3-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.11.3-rc1 applied cleanly to 3.11.2

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
