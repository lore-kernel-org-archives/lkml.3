Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3FZRCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:02:55 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57664 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZRCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:02:53 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-bb-51cb1ebca0b1
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/95] 3.9.8-stable review
Thread-topic: [ 00/95] 3.9.8-stable review
Thread-index: AQHOco79MzEOzSpPDU2dAaM/zJk9bg==
Date: Wed, 26 Jun 2013 17:02:51 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617312A9@sisaex02sj>
References: <20130625183517.651770593@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn+4eudOBBo87VS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MpYvHMWW8F0uYr9HbtZGxg3SnYxcnJICJhILD51lgnCFpO4cG89WxcjF4eQwDJGiTtT
	z7JCOL1MEjsuf2aEcOYzSlza08wM0sImoC7x+fUOdhBbRMBYov/sLDCbWeAYk0RHZxmILSyg
	KdG9+QzQCg6gGi2JJRt0Icr1JHZOvw1WziKgKrFq0Wc2EJtXwF7iwowT7CDlQgJWEouX+4CE
	GYGO+35qDRPEdHGJ5tabLBBHC0gs2XOeGcIWlXj5+B8rSKuEgKLE9tVWEOV6Eh//3GaEsLUl
	nry7wAqxSVDix+R7LBMYxWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyUnlphqFecmFtcmpeu
	l5yfu4kREndVOxjvfLU5xCjAwajEw/uB8XSgEGtiWXFl7iFGCQ5mJRHedyJAId6UxMqq1KL8
	+KLSnNTiQ4xMHJxSDYwiP+9cDUtT/aP5//eHxR9/REb/Xbjhw9wdjApSh2c37Pvw96JRb17H
	55KJ9+7aHz6pKrBkwueEh9JPV3qu+xL3n1HPIHJSJLfkpQ18St9mtHkfuFK0qPz3D6Onx4Xz
	Ll1+eGTzBHW9Da2zGrY0uIcfCQ5n+L/2uuzWphvuIlHpJ8TSUpc/v6F/SImlOCPRUIu5qDgR
	ABE1AgqZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >This is the start of the stable review cycle for the 3.4.51 release.
 >There are 27 patches in this series, all will be posted as a response
 >to this one.  If anyone has any issues with these being applied, please
 >let me know.

 >Responses should be made by Thu Jun 27 18:33:29 UTC 2013.
 >Anything received after that time might be too late.

 >The whole patch series can be found in one patch at:
 >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.51->rc1.gz
 >and the diffstat can be found below.

 >thanks,

 >greg k-h

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
