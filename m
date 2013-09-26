Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3IZCZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:25:17 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64539 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IZCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:25:15 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-94-52439b0a189c
Message-id: <52439B08.1070602@samsung.com>
Date: Wed, 25 Sep 2013 20:25:12 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 000/110] 3.10.13-stable review
References: <20130925001323.387158698@linuxfoundation.org>
In-reply-to: <20130925001323.387158698@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP12u2c5BBrP+KFvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx9uFepoKX3BVrV+xgamA8wtnFyMkhIWAi8Xl9DwuELSZx4d56ti5GLg4hgWWMEis2
	7mCEcHqZJL5/Oc8M4WxilFizvZsVpIVXQEti2ryT7CA2i4CqxOfD9xlBbDYBdYnPr3eAxYUE
	5CSalqxmBrFFBSIkVi55ANUrKPFj8j2w1SICxhL9Z2eB1TMLHGOUWNhsAmILC+hK3GubzAQx
	x0ri4I0JYHM4Bawl9r07xgRRbybxqGUdM4QtL7F5zVtmiHpliT+XTwHVcAC9piixfbXVBEaR
	WUg2z0LSPQtJ9wJG5lWMYqXFyQXFSempFYZ6xYm5xaV56XrJ+bmbGCExU7WD8c5Xm0OMAhyM
	Sjy8Cv+dgoRYE8uKK3MPMUpwMCuJ8H4zcg4S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLjKauK1
	7PsJX1e9cdS9tyAqJf/08+fH2+9V2i8TzLgf6qOes4i11PTBwxeP9Y8WmRjanvkWv0jzcx5f
	2AMfuys2L88kHGSZsq9QM7Rr86b4ByKBjOk9H3IY07doKC6/mGzk0G2y/EPZ0c9l7ivFP2af
	2tLhl9j5zsxg6v71/GcNgt65TYppiFViKc5INNRiLipOBAB2SWupdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep 27 00:12:23 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.13-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.13-rc1 applied cleanly to 3.10.12

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
blackfin: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
