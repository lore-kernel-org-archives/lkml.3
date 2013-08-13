Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab3HMRTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:19:50 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:60767 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3HMRTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:19:47 -0400
X-AuditID: cbfec37d-b7f036d000004805-05-520a6ab24040
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/17] 3.4.58-stable review
Thread-topic: [ 00/17] 3.4.58-stable review
Thread-index: AQHOmDRq4XDjJcbF0UCfhP+DHf72dg==
Date: Tue, 13 Aug 2013 17:19:45 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61763FE4@sisaex02sj>
References: <20130813063501.728847844@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.34.4]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wn+6mLK4ggyvr9SzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo43LiCveA/f8WMyWvZGxin8HYxcnJICJhIXHm/hA3CFpO4cG89kM3FISSwjFGi6+lB
	FpCEkEAvk8TlQyoQifmMEg1rvrOCJNgE1CU+v97BDmKLCBhL9J+dBWYzCxxjkujoLAOxhQW0
	JHqn7GKCqNGWWHtwDTOErSfx9/0ZsDksAqoScyZPZgSxeQXsJTq3wiy2kvhz/w/YTEag676f
	WsMEMV9corn1JgvE1QISS/acZ4awRSVePv7HCmErSKy48YYFol5LYv3O41C92hJP3l1ghdgl
	KPFj8j2WCYxis5CMnYWkZRaSlllIWhYwsqxiFCstTi4oTkpPrTDRK07MLS7NS9dLzs/dxAiJ
	vdodjPe/2hxiFOBgVOLhtbDjChJiTSwrrsw9xCjBwawkwvvVBijEm5JYWZValB9fVJqTWnyI
	kYmDU6qB8ejEdXdPrrqq8VrltFfY0ZtTji4+pVv/6NNVI71Xk1byLTyrIT97yfFJgmurAsKv
	BFZlG/rxTligIzmx1Ngz2jtBXvOinqvJ/9KslfKrLs8rTJ6h0m506O8y29PbNlzxK+vncg8S
	zM2W9JizoyhNM+LsZHWzxqKfF4MZZM5XNr1za5CfPlWeU4mlOCPRUIu5qDgRACeS6x6bAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 08:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.58 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 15 06:34:52 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.58-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Patches applied cleanly to 3.0.90, 3.4.57 and 3.10.6

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.58-rc1, 3.10.7-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.91-rc1, 3.4.58-rc1, and 3.10.7-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.91-rc1, 3.4.58-rc1, and 3.10.7-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.10.y
blackfin: defconfig passed on all
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
