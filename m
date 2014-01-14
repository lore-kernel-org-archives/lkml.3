Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaANTaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:30:00 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64712 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaANT36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:29:58 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-e8-52d590348325
Message-id: <52D59031.8090509@samsung.com>
Date: Tue, 14 Jan 2014 12:29:53 -0700
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
Subject: Re: [PATCH 3.4 00/27] 3.4.77-stable review
References: <20140114002623.356220317@linuxfoundation.org>
In-reply-to: <20140114002623.356220317@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX13TCVeDDBY0M1vMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXR9/kYY8Enzoq9CzYxNzB+YO9i5OCQEDCRaNvv3MXICWSKSVy4t56ti5GLQ0hgGaPE
	7jnXWCGcXiaJfTe3QWU2MEo0vpjOAtLCK6AlMefrESYQm0VAVaLr9RdWEJtNQF3i8+sd7CC2
	kICcRNOS1cwgtqhAhMSrsxOhegUlfky+B2aLCARLrP26kBFkAbPACkaJ4y9fsoEkhAWMJX7/
	msMGMchK4ujbw2A2p4C1xMLmO2CLmQXMJB61rGOGsOUlNq95ywxRryzx5/IpJojfFCRuLFzG
	OoFRZBaS3bOQtM9C0r6AkXkVo1hpcXJBcVJ6aoWxXnFibnFpXrpecn7uJkZI1NTsYLz31eYQ
	owAHoxIP74/wq0FCrIllxZW5hxglOJiVRHjl64FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGK0D
	erzqrOZnNHP++7dwF6+Xqr2SntP/G57NTqw5D+WkfmfoWVkvNNn9RGNS6m5uG4VVOpO/HJl2
	9PKSqJjdsit89/bK/FWoZZ06RW/JkYt+KfMOpvB2XZDk4yxWml30t+Eev9TnE3Grbk5zdzvd
	sUDMvVZ+yk13hWUM1uIZebbbuNPbpzocVWIpzkg01GIuKk4EAARNt7F4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.77 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:26:11 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.77-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patch testing - passed
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
