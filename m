Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3GBSr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:47:59 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:11046 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3GBSr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:47:57 -0400
X-AuditID: cbfec37b-b7f306d0000047de-0f-51d3205ca416
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/13] 3.4.52-stable review
Thread-topic: [ 00/13] 3.4.52-stable review
Thread-index: AQHOdqan+alIMdbhX0OpUS4zOlpUCg==
Date: Tue, 02 Jul 2013 18:47:54 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61734347@sisaex02sj>
References: <20130701200523.096669485@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wr26MwuVAg42fpCzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp4NnE3a0EXf8WDVZuZGhg38XQxcnJICJhILHx+gQnCFpO4cG89WxcjF4eQwDJGiWmP
	rzFDOL1MEpc3TGSBcOYzSryafIkRpIVNQF3i8+sd7CC2iICxRP/ZWWA2s8AxJomOzjIQW1hA
	S+Jwdx8zRI22xO8nfxkhbD2JQzs3Ag3l4GARUJWYdywXJMwrYC/xe/t/VhBbSMBKouvWRRYQ
	mxHouu+n1jBBjBeXaG69yQJxtYDEkj3nmSFsUYmXj/+xgoyUEFCU2L7aCqJcS2L9zuNQrdoS
	T95dYIVYJSjxY/I9lgmMYrOQTJ2FpGUWkpZZSFoWMLKsYhQrLU4uKE5KT60w0itOzC0uzUvX
	S87P3cQIibzqHYx3v9ocYhTgYFTi4XV4dilQiDWxrLgy9xCjBAezkggvt/DlQCHelMTKqtSi
	/Pii0pzU4kOMTBycUg2MC+0elJ6ZIvU3baptV85ud3mL+IKKlJfz9u3TuLQgxzk9ZOuTxxcb
	Hr3odZZ7smB74MazM3KPvH875eOc5rN2K+t4Iy80l1+Sb5j8sud8UdW3h4cZDU30o90Kdyh+
	+b5k4/SVM58//7Fsy2MHtd1tJr9j+3tmu+XPXbxYk/24ZJOir3Oi+tdgVyWW4oxEQy3mouJE
	AO7nUlyaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 04:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.52 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  3 20:03:01 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.52-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.84, 3.4.51, and 3.9.8

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.52-rc1, and 3.9.9-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.85-rc1, 3.4.52-rc1, and 3.9.9-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.85-rc1, 3.4.52-rc1, and 3.9.9-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.9.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
