Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaAGTHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:07:24 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:29818 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaAGTHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:07:18 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-ac-52cc506434ed
Message-id: <52CC5062.3080708@samsung.com>
Date: Tue, 07 Jan 2014 12:07:14 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/144] 3.12.7-stable review
References: <20140106223745.326293132@linuxfoundation.org>
In-reply-to: <20140106223745.326293132@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP92UgDNBBotem1jMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx6lMja0ETV8WklzuZGxg/sXcxcnJICJhITFr8GcoWk7hwbz1bFyMXh5DAMkaJlX23
	mCGcXiaJKU8es0A4Gxkl7k7pYAJp4RXQkjix8hEziM0ioCpx4fJBFhCbTUBd4vPrHWBjhQTk
	JJqWrAarERWIkHh1diILRK+gxI/J98BsEYFgibVfFzKCLGAWWMEocfzlSzaQhLCAmUTDwr8s
	EIOsJD6d7gOyOTg4Bawl9t9IAwkzA5U8alnHDGHLS2xe85YZolxZ4s/lU0wg5RICihLbV1tN
	YBSZhWTzLCTds5B0L2BkXsUoVlqcXFCclJ5aYaxXnJhbXJqXrpecn7uJERIzNTsY7321OcQo
	wMGoxMN7Q+1MkBBrYllxZe4hRgkOZiUR3iAvoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGldwM
	59XUU9daRSTphjAbCL/a7l/B4Mxlr8zkNi/u7eraO3/Zo05uWdsutfxD+R3m/mVuh1lZ7pd+
	Zp17xHrT8udvu2clXPt2Z3fwVc/Qz7FnSmt0P7cdOPYph3fjzZMqXeyhWQkR/Ke2REtOaOZf
	er9jQ8IfJ/3SZxNOrWF8d3VhQaFesZaBEktxRqKhFnNRcSIATR1WK3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 03:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.7 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan  8 22:37:25 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.7-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

Detailed test status

Patches applied cleanly
dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
