Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab3FRWAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:00:38 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:34285 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3FRWAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:00:36 -0400
X-AuditID: cbfec37d-b7f036d000004805-8c-51c0d882b0db
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/7] 3.0.83-stable review
Thread-topic: [ 0/7] 3.0.83-stable review
Thread-index: AQHObG7dPtaDlHu2pUSqnjXOzvqUYA==
Date: Tue, 18 Jun 2013 22:00:33 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172B138@sisaex02sj>
References: <20130618160911.721012782@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9hP92mGwcCDfac0LeYs34Nm8W5BTMY
	LZoXr2ezuLxrDpvF158OFgs2PmK0eNT3lt2B3WPnrLvsHm8fBnicmPGbxWP/3DXsHp83yQWw
	RnHZpKTmZJalFunbJXBlzNpxha3gG39F14z1bA2ME3i7GDk5JARMJLYvfc0KYYtJXLi3nq2L
	kYtDSGAZo8TSmUdZIJxeJomW73uZIJz5jBLfp61iAWlhE1CX+Px6BzuILQJkt/RvYwUpYhb4
	ySQxvfkLI0hCWEBDYsHhS1BFmhIvj2+BsvUk1r89CjaIRUBV4sv5+0C7OTh4Bewl1l00BwkL
	CVhJTP16hw3EZgQ67/upNUwgNrOAuERz600WiLMFJJbsOc8MYYtKvHz8jxVkjISAosT21VYQ
	5VoS63ceh2rVlnjy7gLYx7wCghI/Jt9jmcAoNgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT0
	1AoTveLE3OLSvHS95PzcTYyQaKzdwXj/q80hRgEORiUe3hurDwQKsSaWFVfmHmKU4GBWEuH9
	0wwU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLj4jd3Wcj3Xxe4P6t9/KuW/d7D5idZUpWueKXu1
	t29/5GB1XduvZc2v7xJ3Jzy8EuuV++cs19mDF56tyVrt0hFQVxGdoiozqZKdX2eu2M+gI3dU
	a//ffH58t76O7cqHwXsZV+9v+GTPGTxtStGNvUnbG4IFgt3MxPs+/HE4UmL44vqHOrVdic+U
	WIozEg21mIuKEwHgSQCopAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 03:57 PM, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 3.0.83 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 20 16:07:34 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.83-rc1.gz
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
