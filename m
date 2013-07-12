Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab3GLRUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:20:34 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:33272 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3GLRUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:20:33 -0400
X-AuditID: cbfec37b-b7f306d0000047de-c7-51e03adfd308
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Thread-topic: [ 00/19] 3.10.1-stable review
Thread-index: AQHOfoVlr9dfb0cIXke/moKOzoza1w==
Date: Fri, 12 Jul 2013 17:20:29 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61739C88@sisaex02sj>
References: <20130711214830.611455274@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wr+59qweBBsfXSFvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXRMnEKY8FSgYpFF3gbGDfydjFyckgImEjM/vCfBcIWk7hwbz1bFyMXh5DAMkaJ67/O
	s4MkhAR6mSROPzKASMxnlGj63swIkmATUJf4/HoHWJGIgLFE/9lZYDazwDEmiY7OMhBbWEBL
	4lPfXSaIGm2Jw4vmsULYehJL391mA7FZBFQlvh15BGbzCthLLNz0jBlisZXEteVTwK5jBLru
	+6k1TBDzxSWaW29CXS0gsWTPeWYIW1Ti5eN/QPM5gGxFie2rrSDKtSTW7zwO1aot8eTdBVaI
	VYISPybfY5nAKDYLydRZSFpmIWmZhaRlASPLKkax0uLkguKk9NQKI73ixNzi0rx0veT83E2M
	kLir3sF496vNIUYBDkYlHl4H0QeBQqyJZcWVuYcYJTiYlUR4/xsChXhTEiurUovy44tKc1KL
	DzEycXBKNTAm3+B5zuHxWkjNau296RMXPnwhxsj5KJ5d/rVK77FGB3PX/jgnG99+r58/Gu+s
	ORR170CIgdeiNJ5VPmcbI3iTdlg/PDV5MxPTwgssPkuvy0tIua2qaTPedGOF/gm5xwn921Qe
	ut6t8rIq81/Ft/Bl5goO/4NmvXUOu3SvTF5aaJ8gcGbpxitKLMUZiYZazEXFiQBZxuFAmQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:24 PM, Greg Kroah-Hartman wrote:

>
> This is the start of the stable review cycle for the 3.10.1 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jul 13 21:45:35 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.1-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.85, 3.4.52, 3.9.9, and 3.10

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.53-rc1, 3.9.10-rc1, 3.10.1-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases. dmesg emerg, crit, alert, err are clean.
No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y, and 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, 3.9.y, and 3.10.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
