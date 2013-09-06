Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3IFRwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:52:11 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:33952 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3IFRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:52:08 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-61-522a1647b5bf
Message-id: <522A1645.4060201@samsung.com>
Date: Fri, 06 Sep 2013 11:52:05 -0600
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
Subject: Re: [ 0/7] 3.0.95-stable review
References: <20130905202757.642048278@linuxfoundation.org>
In-reply-to: <20130905202757.642048278@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP113Ma0gg4Vv+C3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4Ntu44AB3xc7lf9gaGBdydjFyckgImEhcubaZHcIWk7hwbz1bFyMXh5DAMkaJ5b1z
	2SGcXiaJS2vmM0I4mxklFr7rZwFp4RXQkph0+SYriM0ioCrx7/M6ZhCbTUBd4vPrHWBjhQTk
	JJqWrAaLiwpESKxc8oAVoldQ4sfke2BzRASMJfrPzgKrZxY4BrSg2QTEFhbQkPi0/zFTFyMH
	0BwriYeL1EHCnALWEqserYMqt5ZYOWkbI4QtL7F5zVtmiLXKEn8unwJrlRBQlNi+2moCo8gs
	JItnIemehaR7ASPzKkax0uLkguKk9NQKQ73ixNzi0rx0veT83E2MkHip2sF456vNIUYBDkYl
	Hl6D25pBQqyJZcWVuYcYJTiYlUR4zzBoBQnxpiRWVqUW5ccXleakFh9iZOLglGpgdPc/Gq+W
	uOhv6OMn0g8fppq/VA/mDdXdfvf5G5vE/cuuZhqqzl62Kd3+64I5zuZmO9wXnGpr8t61/1R6
	E2vlhwMda+NtZ6mY/OHePPfqx7KV0fMvL931XnX+3cwbjvFXti+a3JleNPmDo/u/+Wn737VV
	/ZB5s6rMfsL/ON9Vq+RFKts5vpRKqyqxFGckGmoxFxUnAgCRAsSEdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.95 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep  7 20:27:46 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.95-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.0.95-rc1 applied cleanly to 3.0.94

Compiled and booted on the following systems:

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
tile: tilegx_defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
