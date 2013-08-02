Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3HBT6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:58:45 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:61248 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HBT6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:58:43 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-78-51fc0f713080
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/39] 3.4.56-stable review
Thread-topic: [ 00/39] 3.4.56-stable review
Thread-index: AQHOj5KVqMP9WUEiC0C2nvzLn9ipTg==
Date: Fri, 02 Aug 2013 19:58:40 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175662B@sisaex02sj>
References: <20130802101456.800497005@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wn24R/59Ag3WnWC3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MpY9+YdY8El/oq921gaGN/xdDFyckgImEjsnfOOHcIWk7hwbz1bFyMXh5DAMkaJjZNe
	Qzm9TBJTVp1ihHDmM0q0dsxhAmlhE1CX+Px6B1i7iICxRP/ZWWA2s8AxJomOzjIQW1hAS+L7
	/+ksEDXaErM37mODsPUkfv68CRZnEVCVuHC+F2wmr4C9xLonu5lBbCEBK4ndh/+CzWQEOu/7
	qTVMEPPFJZpbIXolBAQkluw5zwxhi0q8fPyPtYuRA8hWlNi+2gqiXEti/c7jUK3aEk/eXWCF
	WCUo8WPyPZYJjGKzkEydhaRlFpKWWUhaFjCyrGIUKy1OLihOSk+tMNYrTswtLs1L10vOz93E
	CIm8mh2M977aHGIU4GBU4uF9kPkrUIg1say4MvcQowQHs5II78JnvwOFeFMSK6tSi/Lji0pz
	UosPMTJxcEo1MMaZGrMdzVDoncqa1Rd+rYiVQWBJ4xNh6VlvDq6vWvIjJG/J1pN+BvOWfyxn
	DYrcLP06K0RsuSu355QTljWvNJxYxMsDd9heivFwVJhZJqVtphB9W2GJpfsCa/dVBYqyXzlr
	9UzY444232FR8Fb6O3lNV07EklcXONS33dN4u3eaRvrGkjkNSizFGYmGWsxFxYkAMU5K1ZoC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 09:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.56 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug  4 10:13:49 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.56-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.88, 3.4.55 and 3.10.4

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.56-rc1, 3.10.5-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.10.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
