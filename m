Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3JQQvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:51:42 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:51322 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab3JQQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:51:39 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-40-526015994a08
Message-id: <52601571.5010607@samsung.com>
Date: Thu, 17 Oct 2013 10:50:57 -0600
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
Subject: Re: [ 00/69] 3.10.17-stable review
References: <20131016174312.844154919@linuxfoundation.org>
In-reply-to: <20131016174312.844154919@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92ZoglBBkceCVnMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXRuGonU8FSvop3ff9ZGxiXcHcxcnJICJhIzLxwmA3CFpO4cG89kM3FISSwjFHixd9V
	rBBOL5PE1/XroJyNjBJ/Oj8ygrTwCmhJNBxbBWazCKhKNDfNZAWx2QTUJT6/3sEOYgsJyEk0
	LVnNDGKLCkRIrFzygBWiV1Dix+R7LCC2iICxRP/ZWWD1zALHGCUWNpuA2MIC2hJr/55nhZhj
	JXHzViNYPaeAtcT6I4+ZIeqtJVZO2sYIYctLbF7zlhmiXlniz+VTTF2MHECvKUpsX201gVFk
	FpLNs5B0z0LSvYCReRWjWGlxckFxUnpqhaFecWJucWleul5yfu4mRkjMVO1gvPPV5hCjAAej
	Eg+vxM/4ICHWxLLiytxDjBIczEoivK3CCUFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGDl89qru
	fBTt1yl30zx15Tfhtx7POi7e2rpUL95hdme2/5bmxRKeR9lSeZs9nCzMVwqqH5/jdLLkpIZH
	dbDC20Zv5+DG5S+Onv/+IyPp7I+Ek/tWih9ZZKi6NjDX4evS7SqMLdf5P51yzNHKivY7te9k
	M9v+iXNMkuMmcrp251feOyg+55OdvRJLcUaioRZzUXEiAPs/7f93AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 11:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.17 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> You might notice a bunch of ipc patches in this series.  That is to
> resolve some reported ipc bugs / scalabity issues.  Additional testing
> of these code paths would be greatly appreciated.
>
> Responses should be made by Fri Oct 18 17:41:53 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.17-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.17

Patch applied cleanly - yes
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

alpha 	defconfig 	Passed 	Passed
arm 	defconfig 	Passed 	Passed
arm64 	defconfig 	Passed 	Passed
blackfin 	defconfig 	Passed 	Passed
c6x 	defconfig 	Passed 	Passed
mips 	defconfig 	Passed 	Passed
mipsel 	defconfig 	Passed 	Passed
powerpc 	Passed 	Passed
sh 	defconfig 	Passed 	Passed
sparc 	defconfig 	Passed 	Passed
tile 	defconfig 	Passed 	Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
