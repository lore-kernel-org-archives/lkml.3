Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3GXNlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:41:05 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22263 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3GXNlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:41:01 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-78-51efd969629c
From: Shuah Khan <shuah.kh@samsung.com>
To: "gregkh@linuxfoundation.org >> \"Kroah-Hartman, Greg\"" 
	<gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 000/103] 3.10.3-stable review
Thread-topic: [ 000/103] 3.10.3-stable review
Thread-index: AQHOiHDEkcTcHMLbe0e8oFXjGSae9w==
Date: Wed, 24 Jul 2013 13:40:56 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
References: <20130723220418.532514378@linuxfoundation.org>
 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+wn27mzfeBBmvm6lvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx9OUOxoIlghVbPncyNzCu4+ti5OSQEDCRWLFvLxuELSZx4d56IJuLQ0hgGaPEsY39
	UE4vk8TDda8YIZz5jBKLnj1hB2lhE1CX+Px6B5gtIhAlMfv/YXaQImaBvUwSf29dZwJJCAvo
	SMzasJIRokhXonnlLagGPYnNM46A1bAIqEoc7NvG3MXIwcErYC/R0ZYEsayRUWLi7VZWkBpG
	oPu+n1oDVs8sIC7R3HqTBeJuAYkle84zQ9iiEi8f/2MFmSMhoCixfbUVRLmWxPqdx6FatSWe
	vLsANpJXQFDix+R7LBMYxWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyUnlphrFecmFtcmpeu
	l5yfu4kREn01OxjvfbU5xCjAwajEw1sw612gEGtiWXFl7iFGCQ5mJRFeq/nvA4V4UxIrq1KL
	8uOLSnNSiw8xMnFwSjUweqX83iHYd15RhiWP806M5Okwq+BLti6hm4pmrNv8fxKbhKH03k42
	s7XuHF4rjOpnPLVTdOWyYiv9Vid1WT0jKai/X4j3uWP0zdgLHB6K98RP/S98u/Ky3subb/9t
	PvCdYd4PQ0udaWyJ6z/o1ZdLxVuEaiXye26wXvKq6Mq9ZXGKFzJnn9itxFKckWioxVxUnAgA
	yOOGv5wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Tue, Jul 23, 2013 at 4:25 PM
> Subject: [ 000/103] 3.10.3-stable review
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> torvalds@linux-foundation.org, akpm@linux-foundation.org,
> stable@vger.kernel.org
>
>
> This is the start of the stable review cycle for the 3.10.3 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 25 22:01:33 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.3-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
Patch applied cleanly to 3.10.2

Note: When I did a git reset --hard on 3.10.2-rc2 patch,
drivers/acpi/acpi_cmos_rtc.c was left as an untracked file.
I had to remove it before git pull succeeded for 3.10.2.

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
