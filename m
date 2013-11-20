Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3KTP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:28:00 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:41712 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3KTP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:27:58 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-47-528cd4fdc10e
Message-id: <528CD4FB.3080305@samsung.com>
Date: Wed, 20 Nov 2013 08:27:55 -0700
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
Subject: Re: [PATCH 3.10 00/24] 3.10.20-stable review
References: <20131118184222.017393843@linuxfoundation.org>
In-reply-to: <20131118184222.017393843@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92/V3qCDH4/N7SYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSuj9+xTloKbXBU/b21lbWA8wdHFyMkhIWAi0TrzIDuELSZx4d56ti5GLg4hgWWMEmun
	fmCGcHqZJJ5ffACV2cQo8XzJDVaQFl4BLYlVVzeA2SwCqhK9K04ygdhsAuoSn1/vABsrJCAn
	0bRkNTOILSoQIXF09TOoXkGJH5PvsYDYIgLBEmu/LmQEWcAssIJR4vjLl2wgCWEBU4mFq1cy
	QQyyknh76wXQUA4OTgFriUdtyiBhZiBz5aRtjBC2vMTmNW+ZIcqVJf5cPsUEUi4hoCixfbXV
	BEaRWUg2z0LSPQtJ9wJG5lWMYqXFyQXFSempFcZ6xYm5xaV56XrJ+bmbGCExU7OD8d5Xm0OM
	AhyMSjy8BYu6g4RYE8uKK3MPMUpwMCuJ8Hbt7QkS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDil
	U2DzQ0fxLc2zOO012hb3t3TffLXd6GKBcW7ju4rJN6YGO79Tfb9Qvy18y+lTT9vcgu0f5/g0
	LHzmKShelxE0nV1k6h7O6T75U1bW8JjYbBCKW1u3hTvorpG1ilG00/e9q69z+f+tkfj4uJNt
	dVj8vtqct0KeIqFxznqKi908FDe8mzDjjxJLcUaioRZzUXEiAM2Gkdd3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 11:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.20 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Nov 20 18:42:04 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.20-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.20:

patches applied cleanly
Compile test - passed
Boot tests - passed

dmesg regression tests - passed
[dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.]

Cross-compile testing - limited tests passed (alpha, arm, arm64, 
blackfin, c6x, powerpc, sh, sparc, tile)

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
