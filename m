Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3G0ATa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 20:19:30 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22828 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3G0AT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 20:19:27 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-0c-51f3120dd2d2
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/79] 3.10.4-stable review
Thread-topic: [ 00/79] 3.10.4-stable review
Thread-index: AQHOikYd3VshsNg8PkKRMY471eXi0Q==
Date: Sat, 27 Jul 2013 00:19:24 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174D8AC@sisaex01sj>
References: <20130726204721.849052763@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wny6v0OdAg4U7TC3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MpY/L+TqeASf8Wzz2tYGhjf83QxcnJICJhITL6xlh3CFpO4cG89WxcjF4eQwDJGibYF
	+5hAEkICvUwSC2ZmQCTmM0qsWzCNBSTBJqAu8fn1DrBuEQFjif6zs8BsZoFjTBIdnWUgtrCA
	lkTXpQNMEDXaEr1dsxghbD2JrmktYPUsAqoS79pXAW3m4OAVsJdYs1kfYq+VxLbmqcwgNiPQ
	cd9PrWGCGC8u0dx6kwXiaAGJJXvOM0PYohIvH/9jBRkjIaAosX21FUS5lsT6ncehWrUlnry7
	wApi8woISvyYfI9lAqPYLCRTZyFpmYWkZRaSlgWMLKsYxUqLkwuKk9JTKwz1ihNzi0vz0vWS
	83M3MULirmoH452vNocYBTgYlXh4PSd+ChRiTSwrrsw9xCjBwawkwsvM9DlQiDclsbIqtSg/
	vqg0J7X4ECMTB6dUAyNzdbqnjFtb8evXRU/lU3PsQ+cxOl7avaUi40HpruCQtRscs1gvVN6o
	bEs99mlyRvZs6/1z/2lEbQozTrQRu+Fr9GDCvB9L1a88OvrFRrj46iHRJwJz2DoVrpe/Nwz+
	GrDybkXUruNPv76emDLbQ2vVpKv7/6pO8Hl87UmRn3TP3QM2zoESji1KLMUZiYZazEXFiQBn
	+9XqmQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 03:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.4 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 28 20:45:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.87, 3.4.54 and 3.10.3

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.55-rc1, 3.10.4-rc2)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.88-rc1, 3.4.55-rc1, and 3.10.4-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.88-rc1, 3.4.55-rc1, and 3.10.4-rc1)

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
