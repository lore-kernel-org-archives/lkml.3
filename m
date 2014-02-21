Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaBUXmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:42:11 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53508 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaBUXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:42:09 -0500
X-AuditID: cbfec37b-b7f8f6d000007030-9b-5307e45057cc
Message-id: <5307E44E.5010907@samsung.com>
Date: Fri, 21 Feb 2014 16:42:06 -0700
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
Subject: Re: [PATCH 3.13 00/99] 3.13.5-stable review
References: <20140220235118.191692546@linuxfoundation.org>
In-reply-to: <20140220235118.191692546@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP92AJ+zBBudnqVnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxZLVxwX+2iskPmxgbGE+wdjFyckgImEjsnHaGDcIWk7hwbz2QzcUhJLCMUWLNvNVM
	IAkhgV4miavXBCESGxglTuxsYwRJ8ApoSbSt6AXrZhFQlXi56iCYzSagLvH59Q52iGY5iaYl
	q5lBbFGBCIlXZyeyQPQKSvyYfA/MFhEIllj7dSEjyAJmgRWMEsdfvgQbJAx0XsOKNjaIQVYS
	Uz6/AzubU8BaonnGa7A4s4CZxKOWdcwQtrzE5jVvmSHqlSX+XD7FBPGagsSjq63sExhFZiHZ
	PQtJ+ywk7QsYmVcxipUWJxcUJ6WnVhjpFSfmFpfmpesl5+duYoTETPUOxrtfbQ4xCnAwKvHw
	OqSyBwuxJpYVV+YeYpTgYFYS4VVZBBTiTUmsrEotyo8vKs1JLT7EyMTBKdXAmG6fEyb6MKjb
	qTbr6LsdRTMrlgs8ymVazngzuNByR1vd++cHM0x3tOreZpmWnpb6I/9s/iq/zIOL7s5r+Mz1
	xePzad7EzmqVT/dWdy2pKHvG8+by9s6XYeuOTt2YrTTf7O6ivASVbL/442yzV1X6rFNKC04L
	VAgMNLxXf6Zy2yk+/7w/4R96lViKMxINtZiLihMBcmmq6XcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.5 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:51:00 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.5-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
