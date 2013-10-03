Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3JCW4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:56:16 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:23428 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3JCW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:56:15 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-94-524df60e368e
Message-id: <524DF60A.2020304@samsung.com>
Date: Thu, 03 Oct 2013 16:56:10 -0600
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
Subject: Re: [ 00/57] 3.11.4-stable review
References: <20131003040636.600441214@linuxfoundation.org>
In-reply-to: <20131003040636.600441214@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9hP12+b75BBnN/c1nMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxpKeNqWAFT8X75XwNjK84uxg5OSQETCQerPvCDGGLSVy4t56ti5GLQ0hgGaPExM1r
	mCGcXiaJKTt3MoJUCQlsZJTY/EkBxOYV0JLYcuUUK4jNIqAqsWxtD9gkNgF1ic+vd7BD1MtJ
	NC1ZDRYXFYiQWLnkAStEr6DEj8n3WEBsEQFjif6zs8DqmQWOMUosbDbpYuTgEAaav+R0IsQY
	K4nVZ+YygdicAtYS2/pusEKUm0k8alnHDGHLS2xe85YZol5Z4s/lU0wgYyQEFCW2r7aawCgy
	C8niWUi6ZyHpXsDIvIpRrLQ4uaA4KT21wkSvODG3uDQvXS85P3cTIyRaancw3v9qc4hRgINR
	iYc3o943SIg1say4MvcQowQHs5II7+lPQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Ml0T3LV2i
	xjeRr0A64AT71YvBFosONt8WcX3AXi1zRf7bg40c0glT2F/vVDFU/nyq3KHtOcfi5YrL25bx
	ND8Rn7hmQyTDqpZZmaanazd/awyLUCn22/c8PIm3aN3dxhdajvmH/6RyOeu9FGl6dODAq+6T
	B3c6K3/7zB2e3iv/wCq69WX8na3NSizFGYmGWsxFxYkApmma33QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.4 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:06:23 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing: 3.11.4-rc1 applied cleanly to 3.11.3
Compile testing: Passed
Boot testing: Passed
dmesg regression testing: passed. dmesgs look good. No regressions 
compared to the previous dmesgs for this release. dmesg emerg, crit, 
alert, err are clean. No regressions in warn.

Test systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

Cross-compile tests results:

alpha 	defconfig 	Passed
arm 	defconfig 	Passed
arm64 	defconfig 	Passed
blackfin defconfig 	Passed
c6x 	defconfig 	Passed
mips 	defconfig 	Passed
mipsel 	defconfig 	Passed
powerpc wii_defconfig 	Passed
sh 	defconfig 	Passed
sparc 	defconfig 	Passed
tile 	defconfig	Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
