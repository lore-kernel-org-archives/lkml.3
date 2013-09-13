Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3IMXC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:02:58 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:14825 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3IMXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:02:56 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-f7-5233999fa4b5
Message-id: <5233999D.9060402@samsung.com>
Date: Fri, 13 Sep 2013 17:02:53 -0600
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
Subject: Re: [ 00/23] 3.4.62-stable review
References: <20130912174451.748805761@linuxfoundation.org>
In-reply-to: <20130912174451.748805761@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP90FM42DDKb8YLKYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj26+9jAX9PBVTNv1nb2B8wtnFyMkhIWAisXjGe2YIW0ziwr31bF2MXBxCAssYJZYs
	W8wE4fQySZxtusQM4WxilNj2Yy0bSAuvgJbErT+XwNpZBFQlPrb+BrPZBNQlPr/ewQ5iCwnI
	STQtWQ0WFxWIkFi55AErRK+gxI/J91hAbBEBY4n+s7PA6pkFjjFKLGw2AbGFgeZvfzULqIYD
	aI6VxMeeFBCTU8BaYv95I4hqa4mVk7YxQtjyEpvXvGWG2Kos8efyKSaQcgkBRYntq60mMIrM
	QrJ3FpLuWUi6FzAyr2IUKy1OLihOSk+tMNIrTswtLs1L10vOz93ECImX6h2Md7/aHGIU4GBU
	4uGd4W0cJMSaWFZcmXuIUYKDWUmEd9ZdoyAh3pTEyqrUovz4otKc1OJDjEwcnFINjClbi6UF
	Z7QU7lWVSlt2dM0nzZlBexoO+L5edCe99La+zP8NlaXMl/YbiNdkyAnsOHz06Cmh7/y6jqk7
	7XRFKzdnKeboPDl6Vj3rjlRO/4H2nFvPfB3/alU+m9WddOKPcIjDmk42rerafO9nF13lD9po
	ZXPsy17R2BEvetZpdvyJ+FQWxWWsSizFGYmGWsxFxYkAi1Oc8XUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.62 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 17:44:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.62-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.62-rc1 applied cleanly to 3.4.61

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
