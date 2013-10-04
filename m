Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3JDAQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:16:26 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:32317 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JDAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:16:24 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-f7-524e08d7a2dc
Message-id: <524E08D4.9090405@samsung.com>
Date: Thu, 03 Oct 2013 18:16:20 -0600
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
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org>
In-reply-to: <20131003040400.753642257@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP93rHH5BBkv7uS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MpomrieteAqb8WWRafZGhj/cXUxcnJICJhIXF/8kg3CFpO4cG89mC0ksIxRYtr06C5G
	LiC7l0liaetNNghnI6PEnnnrmboYOTh4BbQkHuxWBGlgEVCV+Nn3kh3EZhNQl/j8egc7xCA5
	iaYlq5lBbFGBCImVSx6wgti8AoISPybfYwGxRQSMJfrPzgKrZxY4xiixsNkExBYGGv975kyo
	OVYSO59uYwKxOQWsJZq+n2SBqLeWWDlpGyOELS+xec1bZoh6ZYk/l0+BnSkhoCixfbXVBEaR
	WUg2z0LSPQtJ9wJG5lWMYqXFyQXFSempFSZ6xYm5xaV56XrJ+bmbGCHxUruD8f5Xm0OMAhyM
	Sjy8GfW+QUKsiWXFlbmHGCU4mJVEeE9/AgrxpiRWVqUW5ccXleakFh9iZOLglGpg3OpR/Lxa
	z/hJmvtC7psx7kl7mM4tPDfx0Rqz7TcmG+6Z6DXD5N2dsy6yNUZPHFev3fh0o6RhtrPQZsda
	QfF1O5NeHbl/6taJbz+Tb79653cow7fxQYbSiVlBUj6hP//weBieWyavUmoxu4qdQXCdZE9E
	ocbaTsnlb64Ie55VPxOoeXx/3nZFPyWW4oxEQy3mouJEANoYJC11AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.99 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:03:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.99-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing: 3.0.99-rc1 patch applied with white-space warnings and 
3.0.99-rc2 applied cleanly.

Tested 3.0.99-rc1 and 3.0.99-rc2
Compile testing: 3.0.99-rc1 and 3.0.99-rc2 Passed
Boot testing: 3.0.99-rc1 and 3.0.99-rc2 Passed
dmesg regression testing: passed. dmesgs look good. No regressions 
compared to the previous dmesgs for this release. dmesg emerg, crit, 
alert, err are clean. No regressions in warn.

Test systems

Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile
testing)

Cross-compile tests results

alpha 	defconfig 	Passed
arm 	defconfig 	Passed
arm64 	defconfig 	Not applicable
blackfin defconfig 	Passed
c6x 	defconfig 	Not applicable
mips 	defconfig 	Passed
mipsel 	defconfig 	Passed
powerpc wii_defconfig	Passed
sh 	defconfig 	Passed
sparc 	defconfig 	Passed
tile 	tilegx_defconfig Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
