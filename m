Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3HBT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:57:48 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:38967 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3HBT5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:57:34 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-33-51fc0f2da442
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/99] 3.10.5-stable review
Thread-topic: [ 00/99] 3.10.5-stable review
Thread-index: AQHOj5LAi9lxWX2kykWzlixXBIF8kw==
Date: Fri, 02 Aug 2013 19:57:31 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175660F@sisaex02sj>
References: <20130802100225.478715166@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wn64u/59Ag0W3ZSzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp4vKOHveAMf8X6DVOZGhhf8XQxcnJICJhIrHxxgxHCFpO4cG89WxcjF4eQwDJGifu/
	+xkhnF4mifnvZkNl5jNKTL97lB2khU1AXeLz6x1gtoiAsUT/2VlgNrPAMSaJjs4yEFtYQEvi
	4/p7UDXaEhO73zFC2HoSk47NYwaxWQRUJVadfM8KYvMK2Eus3POUBcQWErCSONjTBGYzAp33
	/dQaJoj54hLNrTdZIM4WkFiy5zwzhC0q8fLxP6A5HEC2osT21VYQ5VoS63ceh2rVlnjy7gLU
	KkGJH5PvsUxgFJuFZOosJC2zkLTMQtKygJFlFaNYaXFyQXFSemqFsV5xYm5xaV66XnJ+7iZG
	SOzV7GC899XmEKMAB6MSD++DzF+BQqyJZcWVuYcYJTiYlUR4Fz77HSjEm5JYWZValB9fVJqT
	WnyIkYmDU6qBccHks8fOTk86KM/H8uzb/WN776797Rn4ZOe6R7y9YaqT9BPmZk1Z+jA+Q/Tv
	oeePPhQIuZ1htXf69+3At0d8rpnOXT+65wsbaievqr7f7X4viLUkYZIpo621l+OCyEmHb+9v
	F2Zca1jd2Bs4gSFrV2Ucw9rpSWEeBZxtMz92XDX+/dow07bjoxJLcUaioRZzUXEiAP8oYN2b	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 09:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.5 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug  4 10:00:45 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.5-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.88, 3.4.55 and 3.10.4

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.56-rc1, 3.10.5-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.10.y
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
