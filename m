Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3FZQ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:57:45 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:15513 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FZQ5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:57:42 -0400
X-AuditID: cbfec37d-b7f036d000004805-3f-51cb1d84fb6e
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/17] 3.0.84-stable review
Thread-topic: [ 00/17] 3.0.84-stable review
Thread-index: AQHOce928x9BQAEPzUiWZCYvQbz+Qw==
Date: Wed, 26 Jun 2013 16:57:39 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61731273@sisaex02sj>
References: <20130625183915.443950649@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wn26L7OlAg29LJS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqY+GkDe8FNuYrDl36yNTC+kOxi5OSQEDCRaN5wkBXCFpO4cG89WxcjF4eQwDJGibWf
	vkM5vUwSGz5shHLmM0psnNzEBNLCJqAu8fn1DnYQW0TAWKL/7Cwwm1ngGJNER2cZiC0soCUx
	7+N55i5GDqAabYnDT9kgyvUkuo71MILYLAKqEkf/vwWL8wrYSyxtXw02RkjASmLp6mnMIDYj
	0HXfT61hghgvLtHcepMF4moBiSV7zjND2KISLx//YwVZJSGgKLF9tRVEuZ7Exz+3GSFsbYkn
	7y6wQqwSlPgx+R7LBEaxWUimzkLSMgtJyywkLQsYWVYxipUWJxcUJ6WnVpjoFSfmFpfmpesl
	5+duYoREXu0OxvtfbQ4xCnAwKvHwfmA8HSjEmlhWXJl7iFGCg1lJhPedCFCINyWxsiq1KD++
	qDQntfgQIxMHp1QDo++Byv9q3YqrRMW2f+e6m7mSkX9q6zTu5AOsG0u+SXzdvm/X8T+vn/Lq
	FRZp+/2eI1F1ylW8T9y5xZTTmm+Ol/Vax57nk9NnCdxP7b7/8qXxpOutM1y49b3bLtw8F174
	/raqVqJqMJP618XlxxZtPWMTrSCy6aL/ZdFrswPmVK0o+3b3z8uOfUosxRmJhlrMRcWJABrC
	B16aAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 04:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.84 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 27 18:35:59 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.84-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.83, 3.4.50, and 3.9.7

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.51-rc1, and 3.9.8-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.84-rc1, 3.4.51-rc1, and 3.9.8-rc1)

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.84-rc1, 3.4.51-rc1, and 3.9.8-rc1)

Cross-compile tests results:

alpha: defconfig passed on 3.0.y and 3.9.y
arm: defconfig passed on 3.0.y and 3.9.y
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y
c6x: not applicable to 3.0.y, defconfig passed 3.9.y
mips: defconfig passed on 3.0.y and 3.9.y
mipsel: defconfig passed on 3.0.y and 3.9.y
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

3.4.51-rc1 build failures:
alpha: (both defconfig and allmodconfig)

   CC [M]  drivers/infiniband/core/addr.o
In file included from include/linux/if_vlan.h:18:0,
                  from include/rdma/ib_addr.h:42,
                  from drivers/infiniband/core/addr.c:47:
include/linux/etherdevice.h: In function ‘ether_addr_equal_64bits’:
include/linux/etherdevice.h:308:9: error: implicit declaration of 
function ‘ether_addr_equal’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/infiniband/core/addr.o] Error 1
make[2]: *** [drivers/infiniband/core] Error 2
make[1]: *** [drivers/infiniband] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

arm: (defconfig)
   CC      drivers/net/Space.o
In file included from drivers/net/Space.c:31:0:
include/linux/etherdevice.h: In function ‘ether_addr_equal_64bits’:
include/linux/etherdevice.h:308:9: error: implicit declaration of 
function ‘ether_addr_equal’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/net/Space.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

mips and mipsel:

   CC      drivers/net/Space.o
In file included from drivers/net/Space.c:31:0:
include/linux/etherdevice.h: In function ‘ether_addr_equal_64bits’:
include/linux/etherdevice.h:308:9: error: implicit declaration of 
function ‘ether_addr_equal’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/net/Space.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
