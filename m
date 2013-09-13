Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3IMXEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:04:11 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:21691 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3IMXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:04:09 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-32-523399e76c7d
Message-id: <523399E5.3090603@samsung.com>
Date: Fri, 13 Sep 2013 17:04:05 -0600
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
Subject: Re: [ 00/19] 3.0.96-stable review
References: <20130912172524.135620246@linuxfoundation.org>
In-reply-to: <20130912172524.135620246@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP90XM42DDCY8ZbSYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj5YYL7AUnuCvuf5jP0sC4nLOLkZNDQsBEoq37EyuELSZx4d56NhBbSGAZo8TGN05d
	jFxAdi+TxNt5r1ggnE2MEru/HmEBqeIV0JJY+WoyYxcjBweLgKrEyjtWIGE2AXWJz693sEMM
	kpNoWrKaGcQWFYiQWLnkAStEq6DEj8n3wMaICBhL9J+dBVbPLHCMUWJhswmILQw0/sH6A0wQ
	c6wkFv+5C9bLKWAt8ejjdjaIemuJlZO2MULY8hKb17xlhqhXlvhz+RQTyGkSAooS21dbTWAU
	mYVk8ywk3bOQdC9gZF7FKFZanFxQnJSeWmGoV5yYW1yal66XnJ+7iRESL1U7GO98tTnEKMDB
	qMTDO8PbOEiINbGsuDL3EKMEB7OSCO+su0ZBQrwpiZVVqUX58UWlOanFhxiZODilGhjlhJky
	+hWvrS2YMq3J5W3gxZ15/6OedotprS2R0qy+HHXS12f1oYbQMPZbKwvyVx+K3Sa3ZF213pRP
	k9IqanKcNxudU9vhvL+bwUg0el9oTHDzJd0r835GL3mo2ft+09XiWPvdSeKmc06YspTyLSxd
	nfIpKvqtSOP1bQwrPLwt/Dvc+D7bOSixFGckGmoxFxUnAgDzvYU0dQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.96 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 17:24:38 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.96-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.0.96-rc1 applied cleanly to 3.0.95

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
arm64: not applicable
blackfin: defconfig passed
c6x: not applicable
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
