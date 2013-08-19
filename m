Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3HSWsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:48:13 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:61105 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3HSWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:48:11 -0400
X-AuditID: cbfec37b-b7f306d0000047de-62-5212a0aa4d13
Message-id: <5212A0A8.6070807@samsung.com>
Date: Mon, 19 Aug 2013 16:48:08 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: Re: [ 00/45] 3.10.8-stable review
References: <20130818203620.996166594@linuxfoundation.org>
In-reply-to: <20130818203620.996166594@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX91VC4SCDJYu07CYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjzoMOtoJv3BUN826yNDCe5exi5OSQEDCRWHluKyOELSZx4d56ti5GLg4hgWWMEt93
	7mWCcHqZJF7O+swOUiUksJFR4uH5AhCbV0BL4sqX7WBxFgFViW2nVrOA2GwC6hKfX++AqpeT
	aFqymrmLkYNDVCBC4uhyTYhWQYkfk++BlYsIGEv0n53FDrKLWWAdo8Tqd0+YQRLCQPMX/T7F
	BjHHSuLnwWtgl3IKWEtcubQKzGYGsldO2gZly0tsXvOWGaJeWeLP5VNMIHslBBQltq+2msAo
	MgvJ6llIumch6V7AyLyKUay0OLmgOCk9tcJIrzgxt7g0L10vOT93EyMkYqp3MN79anOIUYCD
	UYmHt0NJKEiINbGsuDL3EKMEB7OSCG98CVCINyWxsiq1KD++qDQntfgQIxMHp1QDY9u6Ocdv
	qMXonrCpP7Jz4aKc7zZvIst/f01+d052m1/wdPHCGL9ZK/XKW2w7n0y5XjDpwzvF5PsXxF7t
	cmiU6i6oO/b7f/+BWZwXT01asim0Myb8N8ue1LA82yytnxcObbP/bcr9Zcl0Da+JXdN2eGsJ
	yx6yenY49ofAL7H7Qme8pfe2cd3ga1FiKc5INNRiLipOBADaEGvLdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 02:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.8 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Aug 20 20:36:09 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.8-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.8-rc1 applied cleanly to 3.10.7.

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
each of this release. dmesg emerg, crit, alert, err are clean. No 
regressions in warn.

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
tile: tilegx_defconfig passed


-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
