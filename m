Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3JCWzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:55:02 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:58725 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3JCWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:54:59 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-46-524df5c2000b
Message-id: <524DF5BF.4070305@samsung.com>
Date: Thu, 03 Oct 2013 16:54:55 -0600
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
Subject: Re: [ 00/52] 3.10.15-stable review
References: <20131003040522.190209641@linuxfoundation.org>
In-reply-to: <20131003040522.190209641@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX91DX32DDJ5eEbaYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStj/e51bAVreComn2xhbWB8x9nFyMkhIWAicfjhahYIW0ziwr31bF2MXBxCAssYJbZ+
	7WeBcHqZJK6dXM0O4WxklFh8t4sRpIVXQEti05/FTF2MHBwsAqoS37+zgoTZBNQlPr/ewQ5i
	CwnISTQtWc0MYosKREisXPKAFaJVUOLH5Htgm0UEjCX6z84Cq2cWOMYosbDZBMQWFtCW6Fv8
	kQVijpVE5/o5YKs4Bawl3j7ihCi3llg5aRsjhC0vsXnNW2aIcmWJP5dPgZVLCChKbF9tNYFR
	ZBaSxbOQdM9C0r2AkXkVo1hpcXJBcVJ6aoWRXnFibnFpXrpecn7uJkZIvFTvYLz71eYQowAH
	oxIPr0Ctb5AQa2JZcWXuIUYJDmYlEd7Tn4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGFUy+b58
	qdRJlODRfmJV8nzW/8KYhZNNeTgrFhvwyXA8CV1ldvXMQj6lYt5bViL/K9bt5D+ytExR68+0
	dzPKLXf6etVrygsrxFzM0nqclHFmkduOY4kT7pXeCOU66VNtOG//jhe3XFMCZs2b7hH300Ew
	dNNb9wRxc835CUXquSfke12eCRXeV2Ipzkg01GIuKk4EAF6f2Vx1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.15 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:05:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.15-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing: 3.10.15-rc1 applied cleanly to 3.10.14
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
