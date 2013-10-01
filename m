Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3JATWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:22:47 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:45497 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3JATWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:22:40 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-91-524b20ffb474
Message-id: <524B20FC.4050903@samsung.com>
Date: Tue, 01 Oct 2013 13:22:36 -0600
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
Subject: Re: [ 00/49] 3.10.14-stable review
References: <20130929191603.008825488@linuxfoundation.org>
In-reply-to: <20130929191603.008825488@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX93/Ct5BBlcfcFnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXxZw9fwTPuiskLvrE1MB7i7GLk5JAQMJH4snQeM4QtJnHh3nq2LkYuDiGBZYwSV8+8
	Y4Fwepkkmv/0soFUCQlsZJSY89cQxOYV0JK4+uUwE4jNIqAqcXXxRFYQm01AXeLz6x3sEPVy
	Ek1LVoNtEBWIkFi55AErRK+gxI/J91hAbBEBY4n+s7PA6pkFjjFKLGw2AbGFBbQlPpw9ywox
	x0riU8dlsHpOAWuJ5wv3M0PUm0k8alkHZctLbF7zlhmiXlniz+VTQLdxAH2mKLF9tdUERpFZ
	SDbPQtI9C0n3AkbmVYxipcXJBcVJ6akVJnrFibnFpXnpesn5uZsYIfFSu4Px/lebQ4wCHIxK
	PLwSD72ChFgTy4orcw8xSnAwK4nw9vJ7BwnxpiRWVqUW5ccXleakFh9iZOLglGpgDFb9ETF1
	zemzB3a5d7yssN3x5uzjjs+h2x6fkO7ZfqSwjvdihJR5dKG9m5N5Kk9k7IfHK40msYR/EOu7
	van0QzHDVUv5X2Ep7PHHrD5sn7Rh6XmvqQXVSlEuwYw24nvfSB13PnfjiMHlC9ae+u2e5dOe
	BHfw5jv1tiVFpbwJM9qnP0t3qcwzJZbijERDLeai4kQAjMEp7nUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 01:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:15:49 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.14-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.14-rc1 applied cleanly to 3.10.13

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
