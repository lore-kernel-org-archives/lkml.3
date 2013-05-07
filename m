Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3EGTQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:16:12 -0400
Received: from sisa.samsung.com ([63.166.156.250]:39292 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3EGTQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:16:10 -0400
X-ASG-Debug-ID: 1367954139-051129072513c60001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 00/46] 3.0.77-stable review
Thread-Topic: [ 00/46] 3.0.77-stable review
X-ASG-Orig-Subj: Re: [ 00/46] 3.0.77-stable review
Thread-Index: AQHOSzOiC6Plg7dRh0uLtBefdQAFkpj6jTkA
Date: Tue, 7 May 2013 19:14:48 +0000
Message-ID: <1367954088.7469.10.camel@lorien>
References: <20130506225820.628893970@linuxfoundation.org>
	 <CAKocOOM7rXbFbD73ZZ2zmS6SGgaytmWd-36uV+G2OVO88Zb=Og@mail.gmail.com>
In-Reply-To: <CAKocOOM7rXbFbD73ZZ2zmS6SGgaytmWd-36uV+G2OVO88Zb=Og@mail.gmail.com>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.6]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED112C39DA40FE4BAC0E540B04C93C06@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1367954139
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r47JGJZK004937


> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Mon, May 6, 2013 at 4:58 PM
> Subject: [ 00/46] 3.0.77-stable review
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> torvalds@linux-foundation.org, akpm@linux-foundation.org,
> stable@vger.kernel.org
> 
> 
> This is the start of the stable review cycle for the 3.0.77 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed May  8 22:56:20 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.77-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Patches applied cleanly to 3.0.76, 3.4.43, 3.8.11, and 3.9.0 

Compiled and booted on the following systems:

Samsung Series 9 Intel Corei5:
    (3.4.44-rc1, 3.8.12-rc1, and 3.9.1-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
    (3.0.77-rc1, 3.4.44-rc1, 3.8.12-rc1, and 3.9.1-rc)
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
    (cross-compile testing: 3.0.77-rc1, 3.4.44-rc1, 3.8.12-rc1, and
3.9.1-rc1)

dmesgs for all releases look good. No regressions compared to the
previous dmesgs for each of these releases.

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.8.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.8.y.
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all 
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

thanks,
-- Shuah
Shuah Khan Linux Kernel Developer - Open Source Group 
Samsung Research America (Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
