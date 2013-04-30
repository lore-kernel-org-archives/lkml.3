Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab3D3ByI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:54:08 -0400
Received: from mx1.sisa.samsung.com ([63.166.156.249]:57990 "EHLO
	mx1.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab3D3ByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:54:06 -0400
X-ASG-Debug-ID: 1367286845-05c032381e37e60001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 00/34] 3.4.43-stable review
Thread-Topic: [ 00/34] 3.4.43-stable review
X-ASG-Orig-Subj: Re: [ 00/34] 3.4.43-stable review
Thread-Index: AQHORS1I8urLWuFs0EmLkuB4vkKKcJjudi0A
Date: Tue, 30 Apr 2013 01:54:04 +0000
Message-ID: <1367286844.14116.2.camel@lorien>
References: <20130429184700.845644077@linuxfoundation.org>
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.3]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BF06756F5CFDD41827CFD224831D755@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: webmail.sisa.samsung.com[105.144.21.115]
X-Barracuda-Start-Time: 1367286845
X-Barracuda-URL: http://192.168.0.101:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3U1sToE020594

On Mon, 2013-04-29 at 12:02 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.43 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed May  1 18:46:13 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.43-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Patches applied cleanly to 3.0.75, 3.4.42, and 3.8.10 

Compiled and booted on the following systems:

Samsung Series 9 Intel Corei5 (3.4.43-rc1 and 3.8.11-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

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

-- Shuah

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
