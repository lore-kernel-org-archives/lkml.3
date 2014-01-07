Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaAGTJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:09:23 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:32109 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaAGTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:09:15 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-27-52cc50dac90a
Message-id: <52CC50D8.10704@samsung.com>
Date: Tue, 07 Jan 2014 12:09:12 -0700
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
Subject: Re: [PATCH 3.10 000/129] 3.10.26-stable review
References: <20140106223859.589799655@linuxfoundation.org>
In-reply-to: <20140106223859.589799655@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX91bAWeCDK4tV7SYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj3pdlzAVtXBVd12ezNDB+Ye9i5OSQEDCR+Nk1E8oWk7hwbz1bFyMXh5DAMkaJLZ+X
	sEA4vUwSTReaWCGcjYwSvd86mUFaeAU0JN63/GYBsVkEVCVW7+8Ds9kE1CU+v94BNlZIQE6i
	aclqsHpRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3UhI8gCZoEVjBLHX75kA0kIC5hLrL7xmw1i
	kJXEpCc7wRo4BawlJl95yQhiMwuYSTxqWccMYctLbF7zlhmiXlniz+VTTF2MHEC/KUpsX201
	gVFkFpLVs5B0z0LSvYCReRWjWGlxckFxUnpqhbFecWJucWleul5yfu4mRkjU1OxgvPfV5hCj
	AAejEg/vDbUzQUKsiWXFlbmHGCU4mJVEeIO8gEK8KYmVValF+fFFpTmpxYcYmTg4pRoY+TlO
	7Xlz88rzeo0Qvo3Hv9T82n1px9EFtyyvZjj5i3o/PlD4e8WN4PvLr0ZMu1fEuKknt8GR6dq3
	UysOZW145Hy7/aPMKcU7Jm7nZ86vnCJ3b4WuVW/zaVn7lUHX2Lz0Xb/clG3d0CUw//CKOk+H
	//LvOc+u8Jvjvv05n8DOCfM8Hbwdw78fFVViKc5INNRiLipOBAAtBpv3eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 03:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.26 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan  8 22:38:42 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.26-rc1.gz
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
