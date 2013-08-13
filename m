Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3HMRTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:19:06 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:25626 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab3HMRTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:19:03 -0400
X-AuditID: cbfec37d-b7f036d000004805-d7-520a6a86159f
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/12] 3.0.91-stable review
Thread-topic: [ 00/12] 3.0.91-stable review
Thread-index: AQHOmC3tzQeoHQAoNkSiZVWEtmZVRQ==
Date: Tue, 13 Aug 2013 17:19:00 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61763FD7@sisaex02sj>
References: <20130813063520.285638946@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.34.4]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wr25bFleQwcbVUhZz1q9hs2hevJ7N
	4vKuOWwWX386WCzY+IjR4lHfW3YHNo+ds+6ye5yY8ZvFY//cNewenzfJBbBEcdmkpOZklqUW
	6dslcGW8v9rJWPCTv+LuxLXsDYwTeLsYOTkkBEwklt7oY4WwxSQu3FvP1sXIxSEksIxRonvS
	ASYIp5dJ4vD1bewQznxGic8dq8Fa2ATUJT6/3sEOYosIGEv0n50FZjMLHGOS6Ogs62Lk4BAW
	0JK4sskKokRb4vzfv6wQtp7EjMXLwWwWAVWJs0ueMoLYvAL2Et/O/2QCaRUSsJI4vqkCJMwI
	dNz3U2uYIKaLSzS33mSBOFpAYsme88wQtqjEy8f/oJ5RkFhx4w0LRL2WxPqdx6F6tSWevLvA
	CrFKUOLH5HssExjFZiEZOwtJyywkLbOQtCxgZFnFKFZanFxQnJSeWmGiV5yYW1yal66XnJ+7
	iRESebU7GO9/tTnEKMDBqMTDa2HHFSTEmlhWXJl7iFGCg1lJhPerDVCINyWxsiq1KD++qDQn
	tfgQIxMHp1QDo+XlxqON4oXtHTUciZfY1/E1MM8+/eDZoo3/T1tlNt01+Fm0+uOND6+Oxr6/
	0xx99OxC07mFNdNcH22+Zl598M3RPnMes6hfB5Yl3+MUjPvOc3DN1SWnt4lPFLPwvHf0hVPg
	2na1aUcajtR9DFSSO3T3lB2/CvvLm4Y/Q1cIzvXc8u373GJWq4VKLMUZiYZazEXFiQAe9C3j
	mgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 08:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.91 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 15 06:35:11 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.91-rc1.gz
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
