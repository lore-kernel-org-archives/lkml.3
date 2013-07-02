Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3GBSqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:46:15 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54364 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3GBSqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:46:13 -0400
X-AuditID: cbfec37d-b7f036d000004805-a4-51d31ff31d00
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/8] 3.0.85-stable review
Thread-topic: [ 0/8] 3.0.85-stable review
Thread-index: AQHOdp8hnvb8PtT//02uZUYdVWGPVA==
Date: Tue, 02 Jul 2013 18:46:10 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173432A@sisaex02sj>
References: <20130701200232.909858308@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wr+4X+cuBBq1X2SzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp4Mn8CW0ETf8X2400sDYxreLoYOTkkBEwkDh34zgJhi0lcuLeerYuRi0NIYBmjxIen
	X5ghnF4miZ5jH5kgnPmMEv07frKCtLAJqEt8fr2DHcQWETCW6D87C8xmFjjGJNHRWQZiCwto
	SJzZfAmqRlNi369lLBC2nsSXtoVgcRYBVYlvn/aA2bwC9hJ33k5jBrGFBKwknk5/yQRiMwKd
	9/3UGiaI+eISza03oc4WkFiy5zwzhC0q8fLxP6DbOIBsRYntq60gyrUk1u88DtWqLfHk3QVW
	iFWCEj8m32OZwCg2C8nUWUhaZiFpmYWkZQEjyypGsdLi5ILipPTUChO94sTc4tK8dL3k/NxN
	jJDYq93BeP+rzSFGAQ5GJR5eh2eXAoVYE8uKK3MPMUpwMCuJ8HILXw4U4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwHhu7j41obakNQeEo57JnN39ueW7i89HA5PvLgpvuN4ubty1IHC21PGrqtX3
	J9jNuOa35/ymsntySl2Po9O+6K7O8XsibfHNaf2u31xrRRtuLC4vVHxw95RzX3Gk9MJmwU/N
	99ynp02yL2uYbshSzuq6VuNCPf+yFKXOF2Z5pTF8mSafn62rf6TEUpyRaKjFXFScCAA9begW
	mwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 03:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.85 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  3 19:59:07 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.85-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

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
