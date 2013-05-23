Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3EWQwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:52:53 -0400
Received: from mx1.sisa.samsung.com ([63.166.156.249]:47695 "EHLO
	mx1.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288Ab3EWQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:52:51 -0400
X-ASG-Debug-ID: 1369327970-05c03219fb209c0001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/21] 3.9.4-stable review
Thread-Topic: [ 00/21] 3.9.4-stable review
X-ASG-Orig-Subj: Re: [ 00/21] 3.9.4-stable review
Thread-Index: AQHOV0+Twlxq40HiHEC7nfJAqwoYlZkTcqIA
Date: Thu, 23 May 2013 16:52:48 +0000
Message-ID: <1369327968.5427.1.camel@lorien>
References: <20130522205232.597066680@linuxfoundation.org>
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.6]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E4B0790E710FE418EF669CA4AD38ABC@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: webmail.sisa.samsung.com[105.144.21.115]
X-Barracuda-Start-Time: 1369327970
X-Barracuda-URL: http://192.168.0.101:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4NGr0Ax006295

On Wed, 2013-05-22 at 15:10 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.9.4 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri May 24 20:50:18 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.4-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Patches applied cleanly to 3.0.79, 3.4.46, and 3.9.3

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
    (3.4.47-rc1, and 3.9.4-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
    (3.0.80-rc1, 3.4.47-rc1, and 3.9.4-rc1)

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases.

Reviewed patches.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
    (3.0.80-rc1, 3.4.47-rc1, and 3.9.4-rc1)

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

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group 
Samsung Research America (Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
