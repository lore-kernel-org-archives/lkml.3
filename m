Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3HSWx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:53:59 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:8671 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HSWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:53:58 -0400
X-AuditID: cbfec37b-b7f306d0000047de-c5-5212a204b5f0
Message-id: <5212A202.3070708@samsung.com>
Date: Mon, 19 Aug 2013 16:53:54 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: Re: [ 00/12] 3.0.92-stable review
References: <20130818202949.875887601@linuxfoundation.org>
In-reply-to: <20130818202949.875887601@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP12WRUJBBl9/mVvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJUxb8I1xoKn3BUPDuxkbmA8wNnFyMkhIWAi8bh9BhuELSZx4d56IJuLQ0hgGaNE28Ut
	TBBOL5PEppmbmSGcjYwSX/ZeAGvhFdCSeL75FyOIzSKgKjHh0DSwOJuAusTn1zvYQWwhATmJ
	piWrgZo5OEQFIiSOLteEaBWU+DH5HguILSJgLNF/dhY7yHxmgXWMEqvfPWEGSQgDzf+z/QUL
	xBwriccPrjOB2JwC1hKtzc/A9jID2SsnbYOy5SU2r3nLDFGvLPHn8ikmkL0SAooS21dbTWAU
	mYVk9Swk3bOQdC9gZF7FKFZanFxQnJSeWmGkV5yYW1yal66XnJ+7iRESM9U7GO9+tTnEKMDB
	qMTD26EkFCTEmlhWXJl7iFGCg1lJhDe+BCjEm5JYWZValB9fVJqTWnyIkYmDU6qBkT/vm0L4
	DkfBiovX98e3d6tc/iNrJfzbTq3yKpNTiZH+9rLy46saFmXf+TJZ7vbEk4rN21as/mzLlHvC
	420444XNzxbe2PEvJTLo/ln2JRIzg/f9UN67arJt75fbAveXr8kIte8sZYvbwMxzoEAtRrj0
	RMXkurer1BvkdhheDDwckTgr7rdzghJLcUaioRZzUXEiABEgz7B3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 02:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.92 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Aug 20 20:29:24 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.92-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.0.92-rc1 applied cleanly to 3.0.91.

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile test: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: not applicable
blackfin: defconfig passed
c6x: not applicable
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
