Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177Ab3GLRXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:23:49 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15388 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab3GLRXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:23:47 -0400
X-AuditID: cbfec37b-b7f306d0000047de-8c-51e03ba1170e
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/15] 3.9.10-stable review
Thread-topic: [ 00/15] 3.9.10-stable review
Thread-index: AQHOfp6DcM32kLIuLUilzuQUvjdPhQ==
Date: Fri, 12 Jul 2013 17:23:44 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61739CC9@sisaex02sj>
References: <20130711221255.925669600@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wr+5C6weBBq17LS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4u20fS8EUgYrPP58wNzAu4+1i5OSQEDCR+Db7HAuELSZx4d56ti5GLg4hgWWMEnem
	fGGEcHqZJB6sf8MK4cxnlPh+5TA7SAubgLrE59c7wGwRAWOJ/rOzwGxmgWNMEh2dZSC2sICW
	xO3r29ggarQlNr77zwhh60lM3TEDLM4ioCpx8MkVpi5GDg5eAXuJVVOLQcJCAlYSNyesYwWx
	GYGu+35qDRPEeHGJ5tabUFcLSCzZc54ZwhaVePn4HyvIGAkBRYntq60gyrUk1u88DtWqLfHk
	3QWwkbwCghI/Jt9jmcAoNgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT01AojveLE3OLSvHS9
	5PzcTYyQyKvewXj3q80hRgEORiUeXgfRB4FCrIllxZW5hxglOJiVRHj/GwKFeFMSK6tSi/Lj
	i0pzUosPMTJxcEo1MM6qWyC0x9voYjjn6pPXnR73lf16eDSiTdSwY03d41vHAkqv+NbkTYl1
	+8e6QThESGz3h/vuaoYdrzQZDbf72jTM2hox55r9B6+lszRPPZq3wfK7mJZiBOPXh4V3L7Ps
	n9HlK3Zppfy1QKUihlvflR9s+6XxtXinXPA7hsMBQQvPskYnue9k36XEUpyRaKjFXFScCABs
	+tLomgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 07:24 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.9.10 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jul 13 22:11:24 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.10-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.85, 3.4.52, 3.9.9, and 3.10

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.53-rc1, 3.9.10-rc1, 3.10.1-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y, and 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, 3.9.y, and 3.10.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
