Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab3FRVzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:55:19 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22232 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3FRVzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:55:16 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-7a-51c0d743b53a
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/48] 3.9.7-stable review
Thread-topic: [ 00/48] 3.9.7-stable review
Thread-index: AQHObEiy3pmLMgpFfkKnlDAi/Y2meA==
Date: Tue, 18 Jun 2013 21:55:13 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172B0E3@sisaex02sj>
References: <20130618161725.912524266@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9hP13n6wcCDeZt5rOYs34Nm8W5BTMY
	LZoXr2ezuLxrDpvF158OFgs2PmK0eNT3lt2B3WPnrLvsHm8fBnicmPGbxWP/3DXsHp83yQWw
	RnHZpKTmZJalFunbJXBlPJuxn6XgK3/Ft+9rGRsY+3m7GDk5JARMJJ4cOcEEYYtJXLi3nq2L
	kYtDSGAZo8SEU0uZIZxeJomJ004zQjjzGSWutCxkBWlhE1CX+Px6BzuILQJkt/RvYwUpYhb4
	ySQxvfkLUAcHh7CApsSHSfIQNVoSG1atZoKw9SRm3r0CNodFQFWiuf8iM4jNK2Av0bX1HiOI
	LSRgJfHixzY2EJsR6Lzvp9aA9TILiEs0t95kgThbQGLJnvPMELaoxMvH/1hB1koIKEpsX20F
	Ua4lsX7ncahWbYkn7y6wQqwSlPgx+R7LBEaxWUimzkLSMgtJyywkLQsYWVYxipUWJxcUJ6Wn
	VhjqFSfmFpfmpesl5+duYoREY9UOxjtfbQ4xCnAwKvHw3lh9IFCINbGsuDL3EKMEB7OSCO+f
	ZqAQb0piZVVqUX58UWlOavEhRiYOTqkGRvGpX7LYom+eSrtif/pywJZKZWcO6UWPijlzRdzf
	KnS9vr911XbGXxKr/5zWFn13ufrEp2U98ldi3R0OBvlNeWVgaXq/wbnFOqz6k5vgOr19plM8
	dKefEOo7mRtS2nyBr/RUbsL5RR++FrxiOWazWJHfT07+TmqkSPAkNb8OywP/Xh1c49U9WYml
	OCPRUIu5qDgRAEZWxnekAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 11:24 AM, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 3.9.7 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 20 16:15:42 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.7-rc1.gz
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
