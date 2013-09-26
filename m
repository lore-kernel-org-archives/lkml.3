Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3IZCYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:24:07 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64504 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3IZCYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:24:04 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-55-52439ac23cf3
Message-id: <52439AC0.4020603@samsung.com>
Date: Wed, 25 Sep 2013 20:24:00 -0600
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
Subject: Re: [ 00/40] 3.4.63-stable review
References: <20130925001041.939335518@linuxfoundation.org>
In-reply-to: <20130925001041.939335518@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9hP93Ds5yDDCa7WMxZv4bNonnxejaL
	y7vmsFl8/elgsWDjI0aLR31v2R3YPHbOusvucWLGbxaP/XPXsHt83iQXwBLFZZOSmpNZllqk
	b5fAlTG3dxpjQTdPReuLOYwNjE84uxg5OSQETCT+zH3EDGGLSVy4t56ti5GLQ0hgGaPEh+Wd
	UE4vk8TECU+ZIZxNjBInLvSBtfAKaEm0v37FCmKzCKhKbH3SD2azCahLfH69gx3EFhKQk2ha
	shqsXlQgQmLlkgesEL2CEj8m32MBsUUEjCX6z84Cq2cWOMYosbDZBMQWBpr//eYRxi5GDqA5
	VhL9+/xBTE4Ba4nTP6Mgqq0lVk7axghhy0tsXvOWGWKrssSfy6eYQMolBBQltq+2msAoMgvJ
	3llIumch6V7AyLyKUay0OLmgOCk9tcJErzgxt7g0L10vOT93EyMkWmp3MN7/anOIUYCDUYmH
	94Kfc5AQa2JZcWXuIUYJDmYlEd5vRkAh3pTEyqrUovz4otKc1OJDjEwcnFINjPU1dWejDqR+
	dFWbc+yAb/TPZSrZNfe+eZ2PYNg3O9XzaoSj1t3Ekp//5JdpRwhdW/ZGOcmiMsl9mf3xJXve
	Pd/QlFfbtsY5xdBfPPi7hTDvl8nLrzgnsEYel+6wsAt++1NomZVojpjqqZpjMpZZ8lEHPc/Z
	VnPJOyc1L+Vu7Jz29vaVz4p+SizFGYmGWsxFxYkA7+KLEHQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:11 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.63 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep 27 00:09:16 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.63-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.63-rc1 applied cleanly to 3.4.62

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
c6x: dsk6455_defconfig passed - defconfig isn't supported
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
