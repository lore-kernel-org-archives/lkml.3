Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3LSUrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:47:48 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:55915 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3LSUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:47:44 -0500
X-AuditID: cbfec37d-b7ff46d000005528-57-52b35b6f4ab3
Message-id: <52B35B6A.7000502@samsung.com>
Date: Thu, 19 Dec 2013 13:47:38 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/78] 3.10.25-stable review
References: <20131218211111.903835960@linuxfoundation.org>
In-reply-to: <20131218211111.903835960@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX9386M1BBisfSVvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxfFc/S8Elzor5y+awNzCeYe9i5OSQEDCR+LyyGcoWk7hwbz1bFyMXh5DAMkaJvR83
	skM4vUwSszdtZQSpEhLYyChx61UFiM0roCXROKkFLM4ioCrxa9YVMJtNQF3i8+sd7BD1chJN
	S1Yzg9iiAhESR1c/Y4XoFZT4MfkeC4gtIhAssfbrQkaQZcwCOxklni19AZYQFjCVuNO2iAVi
	kJXEhw/ngAZxcHAKWEss2e4BEmYWMJN41LKOGcKWl9i85i0zRLmyxJ/Lp5hAyiUEFCW2r7aa
	wCgyC8nmWUi6ZyHpXsDIvIpRrLQ4uaA4KT21wkSvODG3uDQvXS85P3cTIyRiancw3v9qc4hR
	gINRiYe3wmxzkBBrYllxZe4hRgkOZiUR3p+RQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MVinG
	ydMWL7DYVGRiYH/B+XnRh9I/q95xcm8unnb1h97jZ3XpG5TVCrU9Ur5qXmrUlcxLWXladbu1
	7KZERX1GXrcTzwWn77pQ173C7ex77q3XFOae+q76LmjvyiRDab7fK79OdPi73blx9lN9/03R
	R07yG07QzrvfxHnMky3DL7/myBeJ+3pFSizFGYmGWsxFxYkAZdfZcHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 02:10 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.25 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Dec 20 21:10:56 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.25-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly
Compile testing - passed
Boot testing - passed
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
