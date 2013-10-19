Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3JSDlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 23:41:21 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:48448 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3JSDlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 23:41:19 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-5a-5261ff5ef74e
Message-id: <5261FF5B.9000403@samsung.com>
Date: Fri, 18 Oct 2013 21:41:15 -0600
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
Subject: Re: [ 00/11] 3.4.67-stable review
References: <20131018195049.069623827@linuxfoundation.org>
In-reply-to: <20131018195049.069623827@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX924/4lBBpf7eSzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq49mArW8ENnoprbafYGhg/cXYxcnJICJhI/OnuZISwxSQu3FvP1sXIxSEksIxR4tab
	Q8wQTi+TxJuHt6EyGxklTjxZyQzSwiugJdF3YBlTFyMHB4uAqsTndRogYTYBdYnPr3ewg9hC
	AnISTUtWg5WLCkRIrFzygBWiVVDix+R7LCC2iICxRP/ZWWD1zALHGCUWNpuA2MJA4ye+nwQ1
	x0pi7psONhCbU8BaYtfMPkaIemuJlZO2QdnyEpvXvGWGqFeW+HP5FNhpEgKKEttXW01gFJmF
	ZPMsJN2zkHQvYGRexShWWpxcUJyUnlphpFecmFtcmpeul5yfu4kREjHVOxjvfrU5xCjAwajE
	w9thkxgkxJpYVlyZe4hRgoNZSYS35iJQiDclsbIqtSg/vqg0J7X4ECMTB6dUAyPfpCcTEuqy
	LjnPit6o7WH9h93WRuuJ0fHg6ys8FM4ylH93tRGaPdm73Z094pHfivJ6k7hp56dWa60UKdWo
	PlneGHdWynqDmZ5mdGrk4xkKfUs//dL5dv30jl2djX/ucXypbmN7xbBn4Yv7DR8m2C6X7hAI
	uT7hv7Ziypd+eUfGnQeSts0zuqTEUpyRaKjFXFScCAB9acKBdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 01:53 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.67 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Oct 20 19:50:39 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.67-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly 	 yes
Compile testing          passed
Boot testing 	         passed
dmesg regression testing passed
Cross-compile testing    passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions
in warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile 
testing)

alpha 	defconfig 	Passed
arm 	defconfig 	passed
arm64 	defconfig 	Not applicable
blackfin defconfig 	Passed
c6x 	dsk6455_defconfig Passed
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
