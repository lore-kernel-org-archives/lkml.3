Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab3HMRSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:18:14 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:27259 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab3HMRSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:18:10 -0400
X-AuditID: cbfec37d-b7f036d000004805-9f-520a6a504768
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/60] 3.10.7-stable review
Thread-topic: [ 00/60] 3.10.7-stable review
Thread-index: AQHOmC3IYEMswpIxik+aQrqeWYprJA==
Date: Tue, 13 Aug 2013 17:18:07 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61763FC9@sisaex02sj>
References: <20130813063331.950321483@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.34.4]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wr25gFleQwYlbzBZz1q9hs2hevJ7N
	4vKuOWwWX386WCzY+IjR4lHfW3YHNo+ds+6ye5yY8ZvFY//cNewenzfJBbBEcdmkpOZklqUW
	6dslcGX0bbrEVvCTv+LQ/3ssDYwTeLsYOTkkBEwkmpd1sEDYYhIX7q1n62Lk4hASWMYosWHh
	O3YIp5dJovP8ayhnPqPEk5f7WUFa2ATUJT6/3sEOYosIGEv0n50FZjMLHGOS6OgsA7GFBbQk
	Xj+4xQZRoy2xorsJaB0HkK0nced9OkiYRUBVYuLOB0wgNq+AvcTCJVOZQWwhASuJHb27wFYx
	Al33/dQaJojx4hLNrTehrhaQWLLnPDOELSrx8vE/VghbQWLFjTcsEPVaEut3Hofq1ZZ48u4C
	K8QuQYkfk++xTGAUm4Vk7CwkLbOQtMxC0rKAkWUVo1hpcXJBcVJ6aoWJXnFibnFpXrpecn7u
	JkZI7NXuYLz/1eYQowAHoxIPr4UdV5AQa2JZcWXuIUYJDmYlEd6vNkAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjMmy2948WnI1Z4XZvk6Hqx5ir+fLv3u81/Djy/cFO9NjQhdcuZlSfLn36lT+
	GwUK20p2uZ9J3d+06ep042uqAX3ckdPeM9vf3auZdXshR0Cvr0Lh7sNpImeaDp4T4ttw+PHM
	Hfa6X/b1+N/09a34I/GqMSA2d8qhxSUnj+1gOOZfeUHN1+rT+RQlluKMREMt5qLiRAB9imOV
	mwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 08:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.7 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 15 06:33:14 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.7-rc1.gz
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
