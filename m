Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab3FRWXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:23:16 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:10360 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRWXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:23:13 -0400
X-AuditID: cbfec37b-b7f306d0000047de-e8-51c0ddd03181
From: Shuah Khan <shuah.kh@samsung.com>
To: "greg@kroah.com" <greg@kroah.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Kroah-Hartman, Greg" <gregkh@linuxfoundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/26] 3.4.50-stable review
Thread-topic: [ 00/26] 3.4.50-stable review
Thread-index: AQHObF5G4IBW58fhaUuxevasRNunRw==
Date: Tue, 18 Jun 2013 22:23:11 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172B1A5@sisaex02sj>
References: <20130618161231.154881788@linuxfoundation.org>
 <CAKocOOOnfMbYymOamd8Woy=tmjnQ1i9xGLx-U2Unj8j7sk2RQA@mail.gmail.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+wr+6FuwcCDaYukLKYs34Nm8W5BTMY
	LZoXr2ezuLxrDpvF158OFgs2PmK0eNT3lt2B3WPnrLvsHm8fBnicmPGbxWP/3DXsHp83yQWw
	RnHZpKTmZJalFunbJXBlvJ1ziLlgk1BF70vLBsZZ/F2MnBwSAiYSb79PZ4ewxSQu3FvP1sXI
	xSEksIxRYsriuYwgCSGBXiaJZevdIOz5jBKzDkWB2GwC6hKfX+8AaxYRUJVYvOQIM0gzs8Bn
	Jom9896xgCSEBbQkdm5phirSlljdeo0RwtaTeLX2IzOIzQLUvPUHRJxXwF6i6eAJZohljYwS
	T3/HgdiMQNd9P7WGCcRmFhCXaG69yQJxtYDEkj3nmSFsUYmXj/+xdjFyANmKEttXW0GUa0ms
	33kcqlVb4sm7C6wQqwQlfky+xzKBUWwWkqmzkLTMQtIyC0nLAkaWVYxipcXJBcVJ6akVRnrF
	ibnFpXnpesn5uZsYIZFYvYPx7lebQ4wCHIxKPLwNKw8ECrEmlhVX5h5ilOBgVhLh/dMMFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cAY73uhLUZjRc2+be8Cr+R5dyQxPj+nzTdx8ar58u8XfQ3y
	cQvwd/sqenv2zpiQTced5p6+xs3iyxKmEbH+/nKu0yoGNd8WlH6ckJr/emdLWurzm591Ko68
	inRR2VTLpM+/9+Ckv+FuC2y3yO/fk+zJIc4TuU/3gktO+5GJgv+uXgrR/rLdZmexEktxRqKh
	FnNRcSIAmYoSnKICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Greg Kroah-Hartman <greg@kroah.com>
> Date: Tue, Jun 18, 2013 at 10:14 AM
> Subject: [ 00/26] 3.4.50-stable review
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> torvalds@linux-foundation.org, akpm@linux-foundation.org,
> stable@vger.kernel.org
>
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 3.4.50 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 20 16:10:38 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.50-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Patches applied cleanly to 3.0.82, 3.4.49, and 3.9.6

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.50-rc1, and 3.9.7-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.83-rc1, 3.4.50-rc1, and 3.9.7-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases.

Reviewed patches.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.83-rc1, 3.4.50-rc1, and 3.9.7-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y and 3.9.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
