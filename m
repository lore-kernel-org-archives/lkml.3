Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3IMXCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:02:05 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:14806 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3IMXCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:02:02 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-a7-523399693aa0
Message-id: <52339968.1020907@samsung.com>
Date: Fri, 13 Sep 2013 17:02:00 -0600
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
Subject: Re: [ 00/46] 3.10.12-stable review
References: <20130912175721.001906199@linuxfoundation.org>
In-reply-to: <20130912175721.001906199@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92smcZBBvc2MlvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxdMEb1oJ33BXHu26yNTCe5Oxi5OSQEDCRODL5AxOELSZx4d56ti5GLg4hgWWMEt8u
	r4ByepkkZm88zQzhbGKUmPdjAStIC6+AlsTKGefBbBYBVYkDtyHibALqEp9f72AHsYUE5CSa
	lqxmBrFFBSIkVi55ANUrKPFj8j0WEFtEwFii/+wssHpmgWOMEgubTUBsYQFtiaUb/jNCzLGS
	OHr9EZjNKWAtMf/wLah6M4lHLeuYIWx5ic1r3jJD1CtL/Ll8Cug1DqDXFCW2r7aawCgyC8nm
	WUi6ZyHpXsDIvIpRrLQ4uaA4KT21wlivODG3uDQvXS85P3cTIyRmanYw3vtqc4hRgINRiYf3
	g69xkBBrYllxZe4hRgkOZiUR3ll3jYKEeFMSK6tSi/Lji0pzUosPMTJxcEo1ME6qCogq/Pw9
	4dhH97yp7Dbn5bPj9k+1LDgv/s4/i6vpXuxLpytRO08FBm788ixLoUo9STaO9WCJSkjf8sSr
	BR9qpLnK+H/KGSycLfHI49ma4g23oi6q+ra8V9rL6OOeICzGs3eN7ML3fOYvGT0CD+oqz10k
	/1/koRXDDzsHa3k2ztpFkvXySizFGYmGWsxFxYkAHiiGqncCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.12 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 17:56:26 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.12-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


3.10.12-rc1 applied cleanly to 3.10.11

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
tile: tilegx_defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
