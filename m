Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3HJWIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 18:08:09 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:23137 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab3HJWIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 18:08:07 -0400
X-AuditID: cbfec37b-b7f306d0000047de-f9-5206b9c43598
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/25] 3.4.57-stable review
Thread-topic: [ 00/25] 3.4.57-stable review
Thread-index: AQHOlQhDJ/zMaVCaaEm7PGM/Y4q1EA==
Date: Sat, 10 Aug 2013 22:08:03 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61762F2F@sisaex02sj>
References: <20130809013649.057678051@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9hP90jO9mCDA6fN7SYs34Nm0Xz4vVs
	Fpd3zWGzWLDxEaPFo7637A6sHidm/Gbx2D93DbvH501yAcxRXDYpqTmZZalF+nYJXBkb1i5g
	K/jJX3FmVwtzA+ME3i5GTg4JAROJvy9/s0PYYhIX7q1n62Lk4hASWMYo8f74BXYIp5dJouX8
	OzaQKiGB+YwSy84mg9hsAuoSn1/vAOsWETCW6D87C6yBWWAmk8T/YxOYQBLCAloSuzc+ZIEo
	0pbYenAdI4StJzFx/XTmLkYODhYBVYk9311BwrwC9hJfLzWxQ+yykpjTcgqsnBHouu+n1oCN
	ZBYQl2huvckCcbWAxJI955khbFGJl4//sYKMlBBQlNi+2gqiXEti/c7jUK3aEk/eXWCFWCUo
	8WPyPZYJjGKzkEydhaRlFpKWWUhaFjCyrGIUKy1OLihOSk+tMNIrTswtLs1L10vOz93ECImz
	6h2Md7/aHGIU4GBU4uG9sYEtSIg1say4MvcQowQHs5IIb3slUIg3JbGyKrUoP76oNCe1+BAj
	EwenVANj3P7zseH33mQdm/Z2RtiuV83Tcg+eO/fpsw5jzoV9AYVXi3L8lyX+m2Z0duqdHoHC
	m8vTT9hvrfF6udmP5+adUleevZVBoRLZKvsuqF8Sc9E6/m97o+fT7izr36oJfuYbH655vXvC
	0oTMW61a2z3zdp9bG1jh+YB58vrrhk3a+3sbHzUeas21VWIpzkg01GIuKk4EAAmB3p6RAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 07:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.57 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 11 01:33:13 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.57-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.89, 3.4.56 and 3.10.5

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.57-rc1, 3.10.6-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.90-rc1, 3.4.57-rc1, and 3.10.6-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.90-rc1, 3.4.57-rc1, and 3.10.6-rc1)

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
