Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3H0Umy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:42:54 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11065 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3H0Umw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:42:52 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-f9-521d0f4b63eb
Message-id: <521D0F49.7070601@samsung.com>
Date: Tue, 27 Aug 2013 14:42:49 -0600
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
Subject: Re: [ 00/13] 3.4.60-stable review
References: <20130827010309.850395966@linuxfoundation.org>
In-reply-to: <20130827010309.850395966@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX10fftkgg4kP2CzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqYeOcya8Ev7oqGF0+YGxgvcnYxcnJICJhInF+xiwXCFpO4cG89WxcjF4eQwDJGidad
	TxlBEkICvUwS1w+rQCQ2M0rs2HqOHSTBK6AlcbF3Elg3i4CqxJn2lWwgNpuAusTn1zvYIZrl
	JJqWrGYGsUUFIiRWLnnACtErKPFj8j2wXhEBY4n+s7PA6pkFjjFKLGw2AbGFgebf6t8CdYSV
	xJ3Lc8DqOQWsJS5s+MMCUW8tsXLSNkYIW15i85q3zBD1yhJ/Lp9i6mLkAPpMUWL7aqsJjCKz
	kGyehaR7FpLuBYzMqxjFSouTC4qT0lMrjPWKE3OLS/PS9ZLzczcxQiKmZgfjva82hxgFOBiV
	eHgtNssECbEmlhVX5h5ilOBgVhLhLfkPFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAo+DH/8L3a
	ul/BUl/l/aoavGV9TW92ni6bqaHReEjnxEydcM2eU/cb1Ht5L4faz7Dozg4KUJZ5czfk+6HU
	90/dC15vTijhtFkqPntNQuGf01tfrb2dIT/f4ktYJre5W7j+OcFbFT5t+fsvC221V/i4gnny
	6oWyatxKRY5Xq0P2JdwRScp4oaHEUpyRaKjFXFScCACy6TgydgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 07:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.60 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 29 01:03:03 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.60-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.60
-------
3.4.60-rc1 applied cleanly to 3.4.59

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
