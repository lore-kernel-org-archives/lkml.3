Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3LCVzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:55:19 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:22000 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3LCVzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:55:17 -0500
X-AuditID: cbfec37d-b7fa86d000003175-4d-529e5344a9d8
Message-id: <529E5342.8060505@samsung.com>
Date: Tue, 03 Dec 2013 14:55:14 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 000/173] 3.10.22-stable review
References: <20131202191142.873808297@linuxfoundation.org>
In-reply-to: <20131202191142.873808297@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP12X4HlBBl/vG1nMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxYPN59oKjnBWXn/9mbWDcz97FyMkhIWAi0bP3ByuELSZx4d56ti5GLg4hgWWMElum
	LWSEcHqZJB6s62QGqRIS2Mgo0XClHsTmFdCS2Nn4CSzOIqAqseXiLzYQm01AXeLz6x3sEPVy
	Ek1LVoPViApESBxd/YwVoldQ4sfkeywgtohAsMTarxDLmAVWMEocf/kSbJCwgLnEuWVvgBo4
	gAZZSexaGwQS5hSwluh+9ApsJrOAmcSjlnVQtrzE5jVvoe5Ulvhz+RQTSKuEgKLE9tVWExhF
	ZiHZPAtJ9ywk3QsYmVcxipUWJxcUJ6WnVpjoFSfmFpfmpesl5+duYoRETO0OxvtfbQ4xCnAw
	KvHwcrDPCxJiTSwrrsw9xCjBwawkwrvVDyjEm5JYWZValB9fVJqTWnyIkYmDU6qB0e1xztXu
	l0UWM0PWTVctKPxatPH3jR9ZSUene7nbqhW+/XqiwrIyy140R+YKi7wA57UATmvt5SEHHrjO
	3rR4pbxr09fjuT5vOtO5vM2UT+3UkdvoNPVVnq6uQFhmyfar7EbTWEKUOJNMt8hPas4uXXXm
	VK28i+T1hnRXuQmldxflbPQoX1CixFKckWioxVxUnAgA4ixDi3YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 12:09 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.22 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Dec  4 19:10:16 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.22-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly
compile and boot tests - passed
dmesg regression testing - passed


dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
